#Taken From: https://docs.docker.com/compose/rails/#define-the-project and adapted.
FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /railsApp
WORKDIR /railsApp
COPY Gemfile /railsApp/Gemfile
COPY Gemfile.lock /railsApp/Gemfile.lock
RUN bundle install
COPY . /railsApp
RUN rake db:migrate RAILS_ENV=test
CMD ["rails", "server", "--binding", "0.0.0.0", "RAILS_ENV=test"]
