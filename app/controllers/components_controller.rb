class ComponentsController < ApplicationController
  
  before_filter :login_required
  before_filter :get_page
  cache_sweeper :component_sweeper, :only => [:create, :update, :destroy]
  
  def new
    @component = Component.new
  end
  
  def edit
    @component = Component.find(params[:id])
  end
  
  def create
    @component = @page.components.new(params[:component])
    
    if params[:component][:source_page]
      source = Page.find(params[:component][:source_page], :select => :kind)
      @component.snippet_class = source.kind.singularize.capitalize
    end

    if @component.save
      flash[:notice] = "Component was successfully created"
      redirect_to :controller => @page.kind
    else
      render :action => "new" 
    end
    
  end
  
  def update
    @component = Component.find(params[:id])
    
    if params[:component][:source_page]
      source = Page.find(params[:component][:source_page], :select => :kind)
      snippet_class = {:snippet_class => source.kind.singularize.capitalize}
    else
      snippet_class = {}
    end

    
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
