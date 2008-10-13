class PageSweeper < ActionController::Caching::Sweeper
  observe Page
  
  def after_save(page)
    expire_cache
  end
  
  def after_destroy(page)
    expire_cache
  end
  
  def expire_cache
    FileUtils.rm_rf(Dir['tmp/cache/[^.]*'])
  end

end
