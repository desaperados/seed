class EventsController < ApplicationController
  
  caches_action :index, :unless => :logged_in?
  caches_action :show, :unless => :logged_in?
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :pages_menu, :only => [:index, :new, :edit, :show]
  before_filter :get_page, :except => [:update, :destroy]
  
  def index
    @events = @page.events.paginate(:page => params[:page], :per_page => @page.paginate)
  end
  
  def new
    @event = Event.new
  end
  
  def create
    @event = @page.events.new(params[:event])

    if @event.save
      flash[:notice] = "Event was successfully created"
      redirect_to events_url(@page)
    else
      pages_menu
      render :action => "new" 
    end
  end
  
  def edit
    @event = Event.find(params[:id])
  end
  
  def update
    @event = Event.find(params[:id])
    
    if @event.update_attributes(params[:event])
      flash[:notice] = "Event was successfully updated"
      redirect_to events_url(@event.page_id)
    else
      get_page
      pages_menu
      render :action => "edit"
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to events_url(@event.page_id)
  end
end
