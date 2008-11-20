# Called Newsitems because of route recognition problems
# with just News
class NewsitemsController < ArticlesController
  
  caches_action :archive, :cache_path => Proc.new { |controller|
    controller.params[:month] ?
        controller.send(:archive_url, controller.params[:page_id], controller.params[:month], controller.params[:year]) :
        controller.send(:annual_archive_url, controller.params[:page_id], controller.params[:year])
  }, :unless => :logged_in?
  
  def index
    archive_menu
    @newsitems = @page.newsitems.paginate(:page => params[:page], :per_page => @page.paginate, :order => "created_at DESC")
  end
  
  def archive
    archive_menu
    if params[:month]
      @newsitems = Newsitem.find_all_in_month(params[:year].to_i, params[:month].to_i, params[:page], @page.paginate)
    else
      @newsitems = Newsitem.find_all_in_year(params[:year].to_i, params[:page], @page.paginate)
    end
    render :template => "newsitems/index"
  end
  
  def show
    @newsitem = @page.newsitems.find(params[:id])
  end
  
  private
  
  def archive_menu
    @archive = Newsitem.find(:all, :select => "created_at")
    @years = @archive.group_by {|a| a.created_at.strftime('%Y')}
  end
  
end
