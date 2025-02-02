FROM ruby:2.4.5
RUN apt-get update -qq && apt-get install -y build-essential nodejs imagemagick
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
