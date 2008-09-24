# Called Newsitems because of route recognition problems
# with just News
class NewsitemsController < ApplicationController
  
  before_filter :login_required, :except => [:index]
  before_filter :pages_menu, :only => [:index, :new, :edit]
  before_filter :get_page, :only => [:index, :new, :edit]
  
  def index
    @newsitems = @page.newsitems.paginate(:page => params[:page], :per_page => @page.paginate)
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
  
end
