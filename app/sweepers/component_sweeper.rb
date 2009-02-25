class ComponentSweeper < ActionController::Caching::Sweeper
  observe Component
  
  def after_save(component)
    expire_cache(component)
  end
  
  def after_destroy(component)
    expire_cache(component)
  end
  
  def expire_cache(component)
    expire_fragment "component-#{component.id}"
    
    # clear page index action
    expire_article_index(component)
  end
  
  private
  
  def expire_article_index(component)
    expire_action(component.page.to_param)
    expire_action("#{component.page_id}")
  end

end