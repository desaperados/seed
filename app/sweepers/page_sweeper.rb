class PageSweeper < ActionController::Caching::Sweeper
  observe Page
  
  def after_save(page)
    expire_cache
  end
  
  def after_destroy(page)
    expire_cache
  end
  
  def expire_cache
    expire_fragment 'primary_menu'
    expire_fragment 'secondary_menu'
    FileUtils.rm_rf(Dir['tmp/cache/[^.]*'])
  end

end
