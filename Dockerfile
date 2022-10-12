FROM ruby:3.1-alpine

COPY Gemfile .

RUN bundle install
