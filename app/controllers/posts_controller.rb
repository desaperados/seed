# Blog Posts Controller
class PostsController < ArticlesController
  
  def index
    archive_menu
    if params[:year] && params[:month]
      @posts = Post.find_all_in_month(params[:year].to_i, params[:month].to_i, params[:page], @page.paginate)
    elsif params[:year]
      @posts = Post.find_all_in_year(params[:year].to_i, params[:page], @page.paginate)
    else
      @posts = @page.posts.paginate(:page => params[:page], :per_page => @page.paginate, :order => "created_at DESC")
    end
  end
  
  def show
    @post = @page.posts.find(params[:id])
    if @post.article_type == "post"
      @comment = Comment.new
    end
  end
  
  private
  
  def archive_menu
    @archive = Post.find(:all, :select => "created_at")
    @archive_months = @archive.group_by {|a| a.created_at.strftime('%B')}
    @archive_years = @archive.group_by {|a| a.created_at.strftime('%Y')}
  end
  
end
