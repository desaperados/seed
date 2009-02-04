# Blog Posts Controller
class PostsController < ArticlesController
  
  caches_action :show,
                :unless => :logged_in?, 
                :if => Proc.new { |c| c.params[:nocache] == "t"},
                :cache_path => Proc.new { |c| c.params[:id] }
                
  caches_action :archive,
                :unless => :logged_in?, 
                :cache_path => Proc.new { |c| "page-#{c.params[:page_id]}-archive-#{c.params[:year]}#{c.params[:month]}" }
  
  before_filter :check_view_rights, :only => [:show, :archive]
  
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