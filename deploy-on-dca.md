# Ruby on Rails: Articles example
## By: Edwin Montoya - emontoya@eafit.edu.co
## 2018-1

## DEPLOYMENT ON DCA in VM FOR TESTING

# 1. Deploy the Article Web App on Linux Centos 7.x (test)

## Install ruby and rails

* references:

      https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-centos-7


* Connect remote server: (user1 is a sudo user)

      local$ ssh user1@10.131.137.x
      Password: *****

      user1@test$

* verify and install rvm, ruby, rails, postgres and nginx

* install rvm (https://rvm.io/rvm/install)

        user1@test$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

        user1@test$ \curl -sSL https://get.rvm.io | bash

* reopen terminal app:

        user1@test$ exit

        local$ ssh user1@10.131.137.x
        Password: *****

* install ruby 2.4.1

        user1@test$ rvm list known
        user1@test$ rvm install 2.4.1

* install rails

        user1@test$ gem install rails

## install postgres:

        user1@test$ sudo yum install -y postgresql-server postgresql-contrib postgresql-devel
        Password: *****

        user1@test$ sudo postgresql-setup initdb

        user1@test$ sudo vi /var/lib/pgsql/data/pg_hba.conf

        original:

        host    all             all             127.0.0.1/32            ident
        host    all             all             ::1/128                 ident

        updated:

        host    all             all             127.0.0.1/32            md5
        host    all             all             ::1/128                 md5

* run postgres:

        user1@test$ sudo systemctl start postgresql
        user1@test$ sudo systemctl enable postgresql

* Create Database User:

        user1@test$ sudo su - postgres

        user1@test$ createuser -s pguser

        user1@test$ psql

        postgres=# \password pguser
        Enter new password: changeme

        postgres=# \q

        user1@test$ exit

## Setup RAILS_ENV and PORT (3000 for dev, 4000 for testing or 5000 for production)

        user1@test$ export RAILS_ENV=test
        user1@test$ export PORT=4000

## open PORT on firewalld service:

        user1@test$ sudo firewall-cmd --zone=public --add-port=4000/tcp --permanent
        user1@test$ sudo firewall-cmd --reload

## clone de git repo, install and run:

        user1@test$ mkdir apps
        user1@test$ cd apps
        user1@test$ git clone https://github.com/st0263eafit/appwebArticulosRails.git
        user1@test$ cd appwebArticulosRails
        user1@test$ bundle install
        user1@test$ rake db:drop db:create db:migrate
        user1@test$ export RAILS_ENV=test
        user1@test$ export PORT=4000
        user1@test$ rails server

# SETUP Centos 7.1 in production With Apache Web Server and Passenger.

* Install Apache Web Server

        user1@prod$ sudo yum install httpd
        user1@prod$ sudo systemctl enable httpd
        user1@prod$ sudo systemctl start httpd

        test in a browser: http://10.131.137.236

* Install YARN (https://yarnpkg.com/en/docs/install) (for rake assets:precompile):  

* Install module Passenger for Rails in HTTPD (https://www.phusionpassenger.com/library/install/apache/install/oss/el7/):

        user1@prod$ gem install passenger

        user1@prod$ passenger-install-apache2-module

when finish the install module, add to /etc/http/conf/httpd.conf:

        LoadModule passenger_module /home/user1/.rvm/gems/ruby-2.4.1/gems/passenger-5.1.6/buildout/apache2/mod_passenger.so
        <IfModule mod_passenger.c>
          PassengerRoot /home/user1/.rvm/gems/ruby-2.4.1/gems/passenger-5.1.6
          PassengerDefaultRuby /home/user1/.rvm/gems/ruby-2.4.1/wrappers/ruby
        </IfModule>

* Configure the ruby rails app to use passenger (https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/apache/oss/el7/deploy_app.html):

* summary:

        - clone the repo to /var/www/myapp/appwebArticulosRails

        user1@prod$ cd /var/www/myapp/appwebArticulosRails

        user1@prod$ bundle install --deployment --without development test

        - Configure database.yml and secrets.yml:

        user1@prod$ bundle exec rake secret
        user1@prod$ vim config/secrets.yml

        production:
          secret_key_base: the value that you copied from 'rake secret'

        user1@prod$ bundle exec rake assets:precompile db:migrate RAILS_ENV=production

* add articles.conf to /etc/httpd/conf.d/myapp.conf:

        <VirtualHost *:80>
            ServerName 10.131.137.236

            # Tell Apache and Passenger where your app's 'public' directory is
            DocumentRoot /var/www/myapp/appwebArticulosRails/public

            PassengerRuby /home/user1/.rvm/gems/ruby-2.4.1/wrappers/ruby

            # Relax Apache security settings
            <Directory /var/www/myapp/appwebArticulosRails/public>
                Allow from all
                Options -MultiViews
                # Uncomment this if you're on Apache >= 2.4:
                #Require all granted
            </Directory>
        </VirtualHost>

* restart httpd

        user1@prod$ sudo systemctl restart httpd

        test: http://10.131.137.239

# SETUP Centos 7.1 in production With NGINX with inverse proxy

* Install nginx

        user1@prod$ sudo yum install nginx
        user1@prod$ sudo systemctl enable nginx
        user1@prod$ sudo systemctl start nginx

        test in a browser: http://10.131.137.236

* Rails app is running on 3000 port

        user1@prod$ cd appwebArticulosRails
        user1@prod$ export RAILS_ENV=test
        user1@prod$ export PORT=3000
        user1@prod$ rails server
        => Booting Puma
        => Rails 5.1.2 application starting in test on http://0.0.0.0:3000
        => Run `rails server -h` for more startup options
        Puma starting in single mode...
        * Version 3.9.1 (ruby 2.4.1-p111), codename: Private Caller
        * Min threads: 5, max threads: 5
        * Environment: test
        * Listening on tcp://0.0.0.0:3000
        Use Ctrl-C to stop

* Warning: this app must as a service on Centos.

* Configure /etc/nginx/nginx.conf for Inverse Proxy

      App from browser: http://10.131.137.236/rubyArticulos

      // /etc/nginx/nginx.conf

      location /rubyArticulos/ {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_pass http://127.0.0.1:3000;
        proxy_redirect off;
      }

* MODIFY THE APPLICATION IN ORDER TO CONFIGURE THE NEW URI ('/rubyArticulos'):

      // modify config/routes.rb
      # scope '/' -> run http://server:3000 (native) or http://server (inverse proxy or passenger)
      # scope '/prefix_url' -> run http://server:3000/prefix_url or http://server/prefix_url (inverse proxy or passenger).
      # ej: http://10.131.137.236/rubyArticulos
      Rails.application.routes.draw do
        scope '/rubyArticulos' do
          get 'welcome/index'
          resources :articles
          root 'welcome#index'
        end
      end

* Show new routes and controllers:

      user1@prod$ rails routes

            Prefix    Verb   URI Pattern                                Controller#Action
            welcome_index GET    /rubyArticulos/welcome/index(.:format)     welcome#index
                 articles GET    /rubyArticulos/articles(.:format)          articles#index
                          POST   /rubyArticulos/articles(.:format)          articles#create
              new_article GET    /rubyArticulos/articles/new(.:format)      articles#new
             edit_article GET    /rubyArticulos/articles/:id/edit(.:format) articles#edit
                  article GET    /rubyArticulos/articles/:id(.:format)      articles#show
                          PATCH  /rubyArticulos/articles/:id(.:format)      articles#update
                          PUT    /rubyArticulos/articles/:id(.:format)      articles#update
                          DELETE /rubyArticulos/articles/:id(.:format)      articles#destroy
                    root  GET    /rubyArticulos(.:format)                   welcome#index
