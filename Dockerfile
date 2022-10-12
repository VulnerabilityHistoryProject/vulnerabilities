FROM ruby:3.1-slim

COPY Gemfile .

RUN bundle install
