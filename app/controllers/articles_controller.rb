class ArticlesController < ApplicationController
  
  before_filter :pages_menu, :except => [:create, :update, :destroy]
  before_filter :get_page
  
  def index
    @articles = @page.articles
  end

  def new
    @article = Article.new(:page_id => params[:page_id])
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])

    if @article.save
      flash[:notice] = 'Article was successfully created'
      redirect_to page_articles_path(@page) 
    else
      pages_menu
      render :action => "new" 
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(params[:article])
      flash[:notice] = 'Article was successfully updated'
      redirect_to page_articles_path(@page) 
    else
      pages_menu
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    format.html { redirect_to page_articles_path(@page) }
  end
  
  private 
  
  def get_page
    @page = Page.find(params[:page_id])
  end
end
