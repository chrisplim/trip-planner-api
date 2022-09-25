ARG ELIXIR_VERSION=1.14.0
ARG OTP_VERSION=25.0.4
ARG DISTRIBUTION=alpine
ARG DISTRIBUTION_VERSION=3.16.1

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-${DISTRIBUTION}-${DISTRIBUTION_VERSION}"
ARG RUNNER_IMAGE="${DISTRIBUTION}:${DISTRIBUTION_VERSION}"

FROM ${BUILDER_IMAGE} as builder

RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    make \
    gcc \
    musl-dev

WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv

COPY lib lib

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}

# Install openssl
RUN apk update \
    && apk add openssl ncurses-libs libstdc++ \
    && rm -rf /var/cache/apk/*

# Set the locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /app
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/trip_planner ./

USER nobody

CMD ["/app/bin/server"]
# Appended by flyctl
ENV ECTO_IPV6 true
ENV ERL_AFLAGS "-proto_dist inet6_tcp"
