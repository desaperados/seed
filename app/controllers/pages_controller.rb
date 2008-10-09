class PagesController < ApplicationController

  before_filter :login_required, :except => [:show]
  before_filter :pages_menu, :except => [:create, :update, :destroy, :show]

  def new
    @page = Page.new(:menu_type => "primary")
  end
  
  def show
     @page = Page.find(params[:id])
     redirect_to resources_path(@page) 
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      flash[:notice] = 'Page was successfully created'
      redirect_to resources_path(@page) 
    else
      pages_menu
      render :action => "new" 
    end
  end

  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(params[:page])
      flash[:notice] = 'Page was successfully updated'
      redirect_to resources_path(@page) 
    else
      pages_menu
      render :action => "edit"
    end
  end

  def destroy
    @page = Page.find(params[:id])
    begin
      @page.destroy
      flash[:notice] = "Page deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end
    redirect_to home_url 
  end
  
  private
  
  def resources_path(page)
    eval ("#{page.kind}_path(#{page.id})") 
  end
  
  def current_page
    @current = Page.find(params[:page_id])
  end
end
