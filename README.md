# rubyArticulosEM
## By: Edwin Montoya - emontoya@eafit.edu.co

1. Creating the Article Application

        $ rails article blog

2. Starting up the WebApp Server

        $ rails server

* Open browser: http://localhost:3000

3. Main page: "Hello World"

        $ rails generate controller Welcome index

        edit:
        app/views/welcome/index.html.erb
        config/routes.rb

4. Create REST routes        

* edit: config/routes.rb

        Rails.application.routes.draw do
          get 'welcome/index'

          resources :articles

          root 'welcome#index'
        end

* run:    
          $ rails routes

* output:

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

5. Generate controller for 'articles' REST Services

        $ rails generate controller Articles

* modify: app/controllers/articles_controller.rb
* create: app/views/articles/new.html.erb    

* run: http://localhost:3000/articles/new    

6. Create a FORM HTML to enter data for an article

* edit: app/views/articles/new.html.erb:

      <%= form_for :article do |f| %>
      <p>
        <%= f.label :title %><br>
        <%= f.text_field :title %>
      </p>

      <p>
        <%= f.label :text %><br>
        <%= f.text_area :text %>
      </p>
      <p>
        <%= f.submit %>
      </p>
      <% end %>

  * modify: app/views/articles/new.html.erb:

      <%= form_for :article, url: articles_path do |f| %>

      POST method and require 'create' action.

  * add 'create' action to ArticlesController:

        class ArticlesController < ApplicationController
          def new
          end

          def create
            render plain: params[:article].inspect
          end
        end      
