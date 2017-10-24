FROM ruby:2.4-alpine

RUN apk update && apk add build-base nodejs
ENV RAILS_ENV docker_development

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .

CMD puma -C config/puma.rb