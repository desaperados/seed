class CommentsController < ApplicationController
  
  cache_sweeper :comment_sweeper, :only => [:create, :destroy]
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.request = request
    if @comment.save
      flash[:notice] = "Thanks for the comment"
    else
      flash[:error] = "Unfortunately this comment has been flagged as spam"
    end
    redirect_to post_path(params[:page_id], @comment.post_id)
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Comment deleted"

    redirect_to post_path(params[:page_id], @comment.post_id)
  end
  
end
