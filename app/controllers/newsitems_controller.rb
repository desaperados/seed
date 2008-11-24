# Called Newsitems because of route recognition problems
# with just News
class NewsitemsController < ArticlesController
  
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
