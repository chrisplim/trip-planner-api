ARG ELIXIR_VERSION=1.14.0
ARG OTP_VERSION=25.0.4
ARG DISTRIBUTION=alpine
ARG DISTRIBUTION_VERSION=3.16.1

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-${DISTRIBUTION}-${DISTRIBUTION_VERSION}"
FROM ${BUILDER_IMAGE}

RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    make \
    gcc \
    musl-dev

# Install rebar and hex
RUN mix local.rebar --force && \
    mix local.hex --force

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

RUN mix deps.get

CMD [ "mix", "phx.server" ]