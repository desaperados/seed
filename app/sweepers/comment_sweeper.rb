class CommentSweeper < ActionController::Caching::Sweeper
  observe Comment
  
  def after_save(comment)
    expire_cache(comment) unless !comment.approved?
  end
  
  def after_destroy(comment)
    expire_cache(comment)
  end
  
  def expire_cache(comment)
    #clear post comment count
    expire_action("post-#{comment.post_id}-commentcount")
    
    # clear page index action
    expire_article_index(comment)
    
    # clear show action
    expire_show_page(comment)
  end
  
  private
  
  def expire_show_page(comment)
    expire_action(comment.post.to_param)
    expire_action("#{comment.post_id}")
  end
  
  def expire_article_index(comment)
    expire_action(comment.post.page.to_param)
    if comment.post.page_id == 1
      expire_action("1")
    end
  end

end