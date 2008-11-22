class EventsController < ApplicationController
  
  cache_sweeper :event_sweeper, :only => [:create, :update, :destroy]
  
  #caches_action :index, :cache_path => Proc.new { |controller|
  #  controller.params[:month] ?
  #      controller.send(:browse_url, controller.params[:page_id], controller.params[:month], controller.params[:year]) :
  #      controller.send(:events_url, controller.params[:page_id])
  #}, :unless => :logged_in?
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :get_page, :except => [:update, :destroy]
  
  before_filter :check_view_rights, :only => [:index]
  before_filter :check_edit_rights, :only => [:new, :edit]
  
  def index
    @month = (params[:month]) ? params[:month].to_i : DateTime.now.month
    @year = (params[:year]) ? params[:year].to_i : DateTime.now.year
    @events = Event.current_month_events(@year, @month)
  end
  
  def new
    @event = Event.new
  end
  
  # Redirect to browse url
  def show
    event = Event.find(params[:id])
    redirect_to browse_url(@page, event.date.month, event.date.year)
  end
  
  def create
    @event = @page.events.new(params[:event])

    if @event.save
      flash[:notice] = "Event was successfully created"
      redirect_to events_url(@page)
    else
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
      render :action => "edit"
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to events_url(@event.page_id)
  end
end
