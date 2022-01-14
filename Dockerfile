FROM ruby:3.0.0-alpine AS base

RUN apk add --update --no-cache \
  postgresql-dev \
  tzdata

FROM base AS dependencies

RUN apk add --update --no-cache build-base

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs=3 --retry=3 --verbose

FROM base

WORKDIR /var/www/e-ticketing-system-api

COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

COPY . ./
