FROM hexpm/elixir:1.12.3-erlang-24.1.4-alpine-3.14.2
# FROM elixir:1.14.0-alpine

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