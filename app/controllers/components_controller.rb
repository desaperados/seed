class ComponentsController < ApplicationController
  
  before_filter :login_required
  before_filter :pages_menu
  before_filter :get_page
  
  def new
    @component = Component.new
  end
  
  def edit
    @component = Component.find(params[:id])
  end
  
  def create
    source = Page.find(params[:component][:source_page], :select => :kind)
    
    @component = @page.components.new(params[:component])
    @component.snippet_class = source.kind.singularize.capitalize

    if @component.save
      flash[:notice] = "Component was successfully created"
      redirect_to :controller => @page.kind
    else
      render :action => "new" 
    end
    
  end
  
  def update
    source = Page.find(params[:component][:source_page], :select => :kind)
    
    @component = Component.find(params[:id])
    snippet_class = {:snippet_class => source.kind.singularize.capitalize}
    
    if @component.update_attributes(params[:component].merge(snippet_class))
      flash[:notice] = "Component was successfully updated"
      redirect_to :controller => @page.kind
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @component = Component.find(params[:id])
    @component.destroy

    redirect_to :controller => @page.kind
  end
  
  private 
  
  def get_page
    @page = Page.find(params[:page_id])
  end
   
end
