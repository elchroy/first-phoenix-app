FROM elixir:1.9.0-alpine as build

# install build dependencies
RUN api add --update git build-base nodejs yarn python

# prepare build dir
RUN mkdir /hello
WORKDIR /hello

# install hex + rebar
RUN mix local.hex --force && \
    mix.local.rebar --force


# set build ENV
ENV MIX_ENV=prod


# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile

# build assets
COPY assets assets
COPY priv priv
RUN cd assets && npm install && npm run deploy
RUN mix phx.digest


# build project
COPY lib lib
RUN mix compile


# build release (uncomment COPY if rel/ exists)
COPY rel rel
RUN mix release


# prepare release image
FROM alpine:3.9 AS hello
RUN apk add --update base openssl

RUN mkdir /hello
WORKDIR /hello

COPY --from=build /hello/_build/prod/rel/hello ./
RUN chown -R nobody: /hello
USER nobody

ENV HOME=/hello