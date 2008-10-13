class ComponentSweeper < ActionController::Caching::Sweeper
  observe Component
  
  def after_save(component)
    expire_cache(component)
  end
  
  def after_destroy(component)
    expire_cache(component)
  end
  
  def expire_cache(component)
    FileUtils.rm_rf(Dir["tmp/cache/*/*/pages/[#{component.page_id}+]*"])
  end

end