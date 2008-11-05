class EventSweeper < ActionController::Caching::Sweeper
  observe Event
  
  def after_save(event)
    expire_cache(event)
  end
  
  def after_destroy(event)
    expire_cache(event)
  end
  
  def expire_cache(event)
    FileUtils.rm_rf(Dir["tmp/cache/*/*/pages/[#{event.page_id}+]*"])
  end

end