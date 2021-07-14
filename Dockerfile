FROM ruby:2.7.4

RUN apt-get update && \
    apt-get upgrade -qq && \
    gem install bundler -v 2.2.11

ENV APP_HOME /bowling-api

ADD . $APP_HOME
WORKDIR $APP_HOME

RUN bundle install
