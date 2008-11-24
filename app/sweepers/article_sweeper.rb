class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article
  
  def after_save(article)
    expire_cache(article)
  end
  
  def after_destroy(article)
    expire_cache(article)
  end
  
  def expire_cache(article)
    expire_archive(article) if article.article_type == "post" || article.article_type == "news"
    expire_images(article)
  end
  
  private
  
  def expire_archive(article)
    expire_fragment "page-#{article.page_id}-archive"
  end
  
  def expire_images(article)
    expire_fragment "article-#{article.id}-images"
  end

end
