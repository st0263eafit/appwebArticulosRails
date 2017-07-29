# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

1. Creating the Article Application

        $ rails article blog

2. Starting up the WebApp Server

        $ rails server

Open browser: http://localhost:3000

3. Main page: "Hello World"

        $ rails generate controller Welcome index

        edit:
        app/views/welcome/index.html.erb
        config/routes.rb

4. Create REST routes        

edit: config/routes.rb

        Rails.application.routes.draw do
          get 'welcome/index'

          resources :articles

          root 'welcome#index'
        end

run:    
          $ rails routes

output:

      Prefix Verb   URI Pattern                  Controller#Action
      welcome_index GET    /welcome/index(.:format)     welcome#index
      articles GET    /articles(.:format)          articles#index
             POST   /articles(.:format)          articles#create
      new_article GET    /articles/new(.:format)      articles#new
      edit_article GET    /articles/:id/edit(.:format) articles#edit
      article GET    /articles/:id(.:format)      articles#show
             PATCH  /articles/:id(.:format)      articles#update
             PUT    /articles/:id(.:format)      articles#update
             DELETE /articles/:id(.:format)      articles#destroy
        root GET    /                            welcome#index
