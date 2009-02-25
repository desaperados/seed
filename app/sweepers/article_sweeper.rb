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
    expire_page(article)
    
    # Expire components linked to this article
    components = Component.find(:all, :conditions => ["source_page = ?", article.page_id])
    components.each do |component|
      expire_component(component)
      expire_page(component)
    end
  end
  
  private
  
  def expire_component(component)
    expire_fragment "component-#{component.id}"
  end
  
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
  
  def expire_page(resource)
    expire_action(resource.page.to_param)
    expire_action("#{resource.page_id}")
  end
  
  def expire_show_page(article)
    expire_action(article.to_param)
  end

end
