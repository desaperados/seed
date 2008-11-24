# Blog Posts Controller
class PostsController < ArticlesController
  
  def index
    @posts = @page.posts.paginate(:page => params[:page], :per_page => @page.paginate, :order => "created_at DESC")
  end
  
  def archive
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
  
end
