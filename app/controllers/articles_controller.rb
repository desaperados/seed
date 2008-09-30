class ArticlesController < ApplicationController
  
  before_filter :login_required, :except => [:index]
  before_filter :pages_menu, :only => [:index, :new, :edit, :show]
  before_filter :get_page, :only => [:index, :new, :edit, :show]
  
  def index
    @articles = @page.articles.paginate(:page => params[:page], :per_page => @page.paginate)
  end

  def new
    @article = Article.new(:page_id => params[:page_id])
    @images = []
  end

  def edit
    @article = Article.find(params[:id])
    @images = @article.images
  end

  def create
    @article = Article.new(params[:article])

    if @article.save
      flash[:notice] = "#{@article.article_type.capitalize} was successfully created"
      redirect_to resource_index_page(@article)
    else
      @images = @article.images
      get_page
      pages_menu
      render :action => "new" 
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(params[:article])
      flash[:notice] = "#{@article.article_type.capitalize} was successfully updated"
      redirect_to resource_index_page(@article)
    else
      @images = @article.images
      get_page
      pages_menu
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to resource_index_page(@article)
  end
  
  private 
  
  def get_page
    @page = Page.find(params[:page_id])
  end
  
  def resource_index_page(resource)
    if resource.article_type == "post"
      posts_path(resource.page_id) 
    elsif resource.article_type == "news"
      newsitems_path(resource.page_id) 
    else
      articles_path(resource.page_id) 
    end
  end
  
end
