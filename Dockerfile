FROM elixir:1.7.4-alpine

MAINTAINER Murat Bastas <muratbsts@gmail.com>

RUN mix local.hex --force \
 && apk --update add build-base git postgresql-dev postgresql-client inotify-tools nodejs \
 && mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new-1.3.3.ez \
 && mix local.rebar --force \
 && rm -rf /var/cache/apk/*

ENV MIX_ENV prod

RUN mkdir -p /hasbihal
COPY . /hasbihal
WORKDIR /hasbihal

RUN mix local.hex --force && mix deps.get

EXPOSE 4000

CMD [ "mix", "phx.server" ]
