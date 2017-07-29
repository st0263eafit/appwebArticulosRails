class ArticlesController < ApplicationController
  def new
  end

  def create
    @article = Article.new(params.require(:article).permit(:title, :text))
    @article.save
    redirect_to @article
  end

end
