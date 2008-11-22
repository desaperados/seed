# Blog Posts Controller
class PostsController < ArticlesController
  
  #caches_action :archive, :cache_path => Proc.new { |controller|
  #  controller.params[:month] ?
  #      controller.send(:blog_archive_url, controller.params[:page_id], controller.params[:month], controller.params[:year]) :
  #      controller.send(:blog_annual_archive_url, controller.params[:page_id], controller.params[:year])
  #}, :unless => :logged_in?
  
  def index
    archive_menu
    @posts = @page.posts.paginate(:page => params[:page], :per_page => @page.paginate, :order => "created_at DESC")
  end
  
  def archive
    archive_menu
    if params[:month]
      @posts = Post.find_all_in_month(params[:year].to_i, params[:month].to_i, params[:page], @page.paginate)
    else
      @posts = Post.find_all_in_year(params[:year].to_i, params[:page], @page.paginate)
    end
    render :template => "posts/index"
  end
  
  def show
    @post = @page.posts.find(params[:id])
    if @post.article_type == "post"
      @comment = Comment.new
    end
  end
  
  private
  
  def archive_menu
    @archive = Newsitem.find(:all, :select => "created_at")
    @years = @archive.group_by {|a| a.created_at.strftime('%Y')}
  end
  
end
