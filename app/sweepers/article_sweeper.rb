class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article
  
  def after_save(article)
    expire_cache(article)
  end
  
  def after_destroy(article)
    expire_cache(article)
  end
  
  def expire_cache(article)
    if article.article_type == "post" || article.article_type == "news"
      expire_archive(article)
      expire_show_page(article)
    end
    
    expire_images(article)
    expire_article_index(article)
  end
  
  private
  
  def expire_archive(article)
    # Archive menu fragment
    expire_fragment "page-#{article.page_id}-archive"
    # Archive pages
    expire_action "page-#{article.page.to_param}-archive-#{article.created_at.year}#{article.created_at.month}"
    expire_action "page-#{article.page.to_param}-archive-#{article.created_at.year}"
  end
  
  def expire_images(article)
    expire_fragment "article-#{article.id}-images"
  end
  
  def expire_article_index(article)
    expire_action(article.page.to_param)
    if article.page_id == 1
      expire_action("#{article.page_id}")
    end
  end
  
  def expire_show_page(article)
    expire_action(article.to_param)
  end

end
