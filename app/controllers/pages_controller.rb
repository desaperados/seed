class PagesController < ApplicationController
  
  before_filter :pages_menu, :except => [:create, :update, :destroy]

  def new
    @page = Page.new
    @pages = Page.pages_for_dropdown
  end

  def edit
    @page = Page.find(params[:id])
    @pages = Page.pages_for_dropdown(params[:id])
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      flash[:notice] = 'Page was successfully created'
      redirect_to page_articles_path(@page) 
    else
      @pages = Page.pages_for_dropdown(params[:id])
      pages_menu
      render :action => "new" 
    end
  end

  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(params[:page])
      flash[:notice] = 'Page was successfully updated'
      redirect_to(@page) 
    else
      @pages = Page.pages_for_dropdown(params[:id])
      pages_menu
      render :action => "edit"
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    redirect_to home_url 
  end
end
