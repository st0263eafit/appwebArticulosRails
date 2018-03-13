# rubyArticulosEM
## By: Edwin Montoya - emontoya@eafit.edu.co

# DEVELOPMENT:

## 1. Creating the Article Application

        user1@dev$ rails new appwebArticulosRails

## 2. Starting up the WebApp Server

        user1@dev$ rails server

* Open browser: http://localhost:3000

## 3. Main page: "Hello World"

        user1@dev$ rails generate controller Welcome index

        edit:
        app/views/welcome/index.html.erb
        config/routes.rb

## 4. Create REST routes        

* edit: config/routes.rb
      # scope '/' -> run http://server:3000 (native) or http://server (inverse proxy or passenger)
      # scope '/prefix_url' -> run http://server:3000/prefix_url or http://server/prefix_url (inverse proxy or passenger).
      # ej: http://10.131.137.236/rubyArticulos
        Rails.application.routes.draw do
          scope '/' do
            get 'welcome/index'
            resources :articles
            root 'welcome#index'
          end
        end

* run:    
        user1@dev$ rails routes

* output:

      Prefix Verb   URI Pattern                  Controller#Action
      welcome_index GET    /welcome/index(.:format)     welcome#index
          articles  GET    /articles(.:format)          articles#index
                    POST   /articles(.:format)          articles#create
      new_article   GET    /articles/new(.:format)      articles#new
      edit_article  GET    /articles/:id/edit(.:format) articles#edit
        article     GET    /articles/:id(.:format)      articles#show
                    PATCH  /articles/:id(.:format)      articles#update
                    PUT    /articles/:id(.:format)      articles#update
                    DELETE /articles/:id(.:format)      articles#destroy
              root  GET    /                            welcome#index

## 5. Generate controller for 'articles' REST Services

        user1@dev$ rails generate controller Articles

* modify: app/controllers/articles_controller.rb
* create: app/views/articles/new.html.erb    

* run: http://localhost:3000/articles/new    

## 6. Create a FORM HTML to enter data for an article

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

## 7. Creating the Article model

      user1@dev$ rails generate model Article title:string text:text

* look db/migrate/YYYYMMDDHHMMSS_create_articles.rb:

      class CreateArticles < ActiveRecord::Migration[5.0]
        def change
          create_table :articles do |t|
            t.string :title
            t.text :text

            t.timestamps
          end
        end
      end

## 8. Running a Migration

run:

    user1@dev$ rails db:migrate

## include postgresql in test and production environment:

(Warning: install postgresql server on host)

* Modify Gemfile

      # Use Postgresql as the database for Active Record
      gem 'pg'

* Modify config/database.yml:

      test:
          adapter: postgresql
          database: articulosem_test
          user: pguser
          password: changeme
          host: db
          port: 5432
          pool: 5
          pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
          timeout: 5000

      production:
          adapter: postgresql
          database: articulosem
          user: pguser
          password: changeme
          host: db
          port: 5432
          pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
          timeout: 5000    

* Drop, Create and migrate new database:

          user1@dev$ rake db:drop db:create db:migrate

## 9. Saving data in the controller

* Open app/controllers/articles_controller.rb

      def create
        @article = Article.new(params[:article])

        @article.save
        redirect_to @article
      end

* fix1:

      @article = Article.new(params.require(:article).permit(:title, :text))

* fix2:

      def create
        @article = Article.new(article_params)

        @article.save
        redirect_to @article
      end

      private
        def article_params
          params.require(:article).permit(:title, :text)
        end      

## 10. Showing Articles

* Route:

      article GET    /articles/:id(.:format)      articles#show

* Controller: add action in app/controllers/articles_controller.rb

      def show
        @article = Article.find(params[:id])
      end

* View: create a new file app/views/articles/show.html.erb

      <p>
        <strong>Title:</strong>
        <%= @article.title %>
      </p>

      <p>
        <strong>Text:</strong>
        <%= @article.text %>
      </p>    

## 11. Listing all articles

* Route:

      articles GET    /articles(.:format)          articles#index

* Controller: add action in app/controllers/articles_controller.rb

      def index
         @articles = Article.all
      end

* View: create a new file app/views/articles/index.html.erb

      <h1>Listing articles</h1>

      <table>
        <tr>
          <th>Title</th>
          <th>Text</th>
          <th></th>
        </tr>

        <% @articles.each do |article| %>
          <tr>
            <td><%= article.title %></td>
            <td><%= article.text %></td>
            <td><%= link_to 'Show', article_path(article) %></td>
          </tr>
        <% end %>
      </table>

## 12. Adding links

* View: Open app/views/welcome/index.html.erb

      <h1>Hello World EAFIT</h1>
      <%= link_to 'My Articles', controller: 'articles' %>  

* View: app/views/articles/index.html.erb

      <%= link_to 'New article', new_article_path %>    

* View: app/views/articles/new.html.erb


      <%= form_for :article, url: articles_path do |f| %>
        ...
      <% end %>

      <%= link_to 'Back', articles_path %>

* View: app/views/articles/show.html.erb

      <p>
        <strong>Title:</strong>
        <%= @article.title %>
      </p>

      <p>
        <strong>Text:</strong>
        <%= @article.text %>
      </p>

      <%= link_to 'Back', articles_path %>   

## 13. Updating Articles     

* Route:     

      article GET    /articles/:id(.:format)      articles#show

* Controller: edit action to the ArticlesController ->  app/controllers/articles_controller.rb

      def edit
      @article = Article.find(params[:id])
      end

* View: new page: app/views/articles/edit.html.erb

      <h1>Edit article</h1>

      <%= form_for(@article) do |f| %>

        <% if @article.errors.any? %>
          <div id="error_explanation">
            <h2>
              <%= pluralize(@article.errors.count, "error") %> prohibited
              this article from being saved:
            </h2>
            <ul>
              <% @article.errors.full_messages.each do |msg| %>
                <li><%= msg %></li>
              <% end %>
            </ul>
          </div>
        <% end %>

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

      <%= link_to 'Back', articles_path %>  

* Controller: update action in app/controllers/articles_controller.rb

      def update
        @article = Article.find(params[:id])

        if @article.update(article_params)
          redirect_to @article
        else
          render 'edit'
        end
      end

* View: add link 'edit' in app/views/articles/index.html.erb

      <table>
        <tr>
          <th>Title</th>
          <th>Text</th>
          <th colspan="2"></th>
        </tr>

        <% @articles.each do |article| %>
          <tr>
            <td><%= article.title %></td>
            <td><%= article.text %></td>
            <td><%= link_to 'Show', article_path(article) %></td>
            <td><%= link_to 'Edit', edit_article_path(article) %></td>
          </tr>
        <% end %>
      </table>

* View: add link 'edit' in app/views/articles/show.html.erb:

      ...
      <%= link_to 'Edit', edit_article_path(@article) %> |
      <%= link_to 'Back', articles_path %>

## 14. delete an Article

Route:

      DELETE /articles/:id(.:format)      articles#destroy  

Controller: app/controllers/articles_controller.rb

      def destroy
        @article = Article.find(params[:id])
        @article.destroy

        redirect_to articles_path
      end                                      

View: add 'delete' link to app/views/articles/index.html.erb

      ...
      <td><%= link_to 'Edit', edit_article_path(article) %></td>
      <td><%= link_to 'Delete', article_path(article), method: :delete,
              data: { confirm: 'Are you sure?' } %></td>
      ...

## DEPLOYMENT ON DOCKER FOR TESTING

### Install Docker

#### Ubuntu

    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu$(lsb_release -cs) stable"
    $ sudo apt-get update
    $ sudo apt-get install docker-ce

#### Windows

Download the official docker installer [Docker](https://docs.docker.com/docker-for-windows/install/)

#### OSX

Download the official docker installer  [Docker](https://docs.docker.com/docker-for-mac/install/)

#### Download Git repository

      $ cd /tmp/
      $ mkdir apps
      $ cd apps
      $ git clone https://github.com/st0263eafit/appwebArticulosNodejs.git
      $ cd appwebArticulosNodejs

#### Execute docker-compose

    $ docker-compose up

Check the deployment by going to the URL [0.0.0.0:3000](0.0.0.0:3000)

@20181            
