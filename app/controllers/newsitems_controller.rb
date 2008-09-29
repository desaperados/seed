# Called Newsitems because of route recognition problems
# with just News
class NewsitemsController < ArticlesController
  
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
  
  private
  
  def archive_menu
    @archive = Newsitem.find(:all, :select => "created_at")
    @archive_months = @archive.group_by {|a| a.created_at.strftime('%B')}
    @archive_years = @archive.group_by {|a| a.created_at.strftime('%Y')}
  end
  
end
