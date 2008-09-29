# Called Newsitems because of route recognition problems
# with just News
class NewsitemsController < ApplicationController
  
  before_filter :login_required, :except => [:index]
  before_filter :pages_menu, :only => [:index, :new, :edit]
  before_filter :get_page, :only => [:index, :new, :edit]
  
  def index
    archive_menu
    if params[:year] && params[:month]
      @newsitems = Newsitem.find_all_in_month(params[:year].to_i, params[:month].to_i, params[:page], @page.paginate)
    elsif params[:year]
      @newsitems = Newsitem.find_all_in_year(params[:year].to_i, params[:page], @page.paginate)
    else
      @newsitems = @page.newsitems.paginate(:page => params[:page], :per_page => @page.paginate, :order => "created_at DESC")
    end
  end
  
  def new
    @newsitem = Newsitem.new(:page_id => params[:page_id])
  end

  def edit
    @newsitem = Newsitem.find(params[:id])
  end

  def create
    @newsitem = Newsitem.new(params[:newsitem])

    if @newsitem.save
      flash[:notice] = 'Newsitem was successfully created'
      redirect_to newsitems_path(@newsitem.page_id) 
    else
      pages_menu
      render :action => "new" 
    end
  end

  def update
    @newsitem = Newsitem.find(params[:id])

    if @newsitem.update_attributes(params[:newsitem])
      flash[:notice] = 'Newsitem was successfully updated'
      redirect_to newsitems_path(@newsitem.page_id) 
    else
      pages_menu
      render :action => "edit"
    end
  end

  def destroy
    @newsitem = Newsitem.find(params[:id])
    @newsitem.destroy

    redirect_to newsitems_path(@newsitem.page_id)
  end
  
  private
  
  def get_page
    @page = Page.find(params[:page_id])
  end
  
  def archive_menu
    @archive = Newsitem.find(:all, :select => "created_at")
    @archive_months = @archive.group_by {|a| a.created_at.strftime('%B')}
    @archive_years = @archive.group_by {|a| a.created_at.strftime('%Y')}
  end
  
end
