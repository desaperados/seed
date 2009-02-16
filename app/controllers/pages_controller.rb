class PagesController < ApplicationController

  before_filter :login_required, :except => [:show]
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]
  require_role "admin"
  
  def index
    @viewable = Role.pages_for_viewable_by
    @editable = Role.pages_for_editable_by
    @parents = ['parent_0', 'parent_00']
    Page.all_parents.each { |p| @parents << "parent_#{p.parent_id}"}
  end

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
      render :action => "new" 
    end
  end

  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(params[:page])
      flash[:notice] = 'Page was successfully updated'
      redirect_to resources_path(@page) 
    else
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

end
