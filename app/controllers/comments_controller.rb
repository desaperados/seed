class CommentsController < ApplicationController
  
  cache_sweeper :comment_sweeper, :only => [:create, :destroy]
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.request = request
    if @comment.save && @comment.approved?
      flash[:notice] = "Thanks for the comment"
    else
      flash[:error] = "Unfortunately this comment has been flagged as spam. " +
                      "It has been referreed to an administrator"
    end
    redirect_to post_path(params[:page_id], @comment.post_id, :nocache => "t")
  end
  
  def destroy_multiple
    Comment.destroy(params[:comment_ids])
    flash[:notice] = "Successfully destroyed comments."
    redirect_to post_path(params[:page_id], params[:postid])
  end

  def approve
    @comment = Comment.find(params[:id])
    @comment.mark_as_ham!
    redirect_to post_path(params[:page_id], @comment.post_id)
  end

  def reject
    @comment = Comment.find(params[:id])
    @comment.mark_as_spam!
    redirect_to post_path(params[:page_id], @comment.post_id)
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Comment deleted"

    redirect_to post_path(params[:page_id], @comment.post_id)
  end
  
end
