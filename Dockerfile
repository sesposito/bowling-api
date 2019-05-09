FROM ruby:2.6.1

RUN apt-get update && \
    apt-get upgrade -qq && \
    gem install bundler -v 2.0.1

ENV APP_HOME /bowling-api

ADD . $APP_HOME
WORKDIR $APP_HOME

RUN bundle install
