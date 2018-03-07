#Taken From: https://docs.docker.com/compose/rails/#define-the-project and adapted.
FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /railsApp
WORKDIR /railsApp
COPY Gemfile /railsApp/Gemfile
COPY Gemfile.lock /railsApp/Gemfile.lock
RUN bundle install
COPY . /railsApp
RUN ls /railsApp
RUN rake db:migrate
