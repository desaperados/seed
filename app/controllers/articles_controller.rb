class ArticlesController < ApplicationController
  
  before_filter :login_required, :except => [:index]
  before_filter :pages_menu, :only => [:index, :new, :edit]
  before_filter :get_page, :only => [:index, :new, :edit]
  
  def index
    @articles = @page.articles.paginate(:page => params[:page], :per_page => @page.paginate)
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
      redirect_to articles_path(@article.page_id) 
    else
      pages_menu
      render :action => "new" 
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(params[:article])
      flash[:notice] = 'Article was successfully updated'
      redirect_to articles_path(@article.page_id) 
    else
      pages_menu
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path(@article.page_id)
  end
  
  private 
  
  def get_page
    @page = Page.find(params[:page_id])
  end
end
