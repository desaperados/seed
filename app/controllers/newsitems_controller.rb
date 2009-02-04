# Called Newsitems because of route recognition problems
# with just News
class NewsitemsController < ArticlesController
  
  caches_action :show,
                :unless => :logged_in?, 
                :cache_path => Proc.new { |c| c.params[:id] }
                
  caches_action :archive,
                :unless => :logged_in?, 
                :cache_path => Proc.new { |c| "page-#{c.params[:page_id]}-archive-#{c.params[:year]}#{c.params[:month]}" }
  
  before_filter :check_view_rights, :only => [:show, :archive]
  
  def index
    @newsitems = @page.newsitems.paginate(:page => params[:page], :per_page => @page.paginate, :order => "created_at DESC")
  end
  
  def archive
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
  
end
