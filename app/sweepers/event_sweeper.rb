class EventSweeper < ActionController::Caching::Sweeper
  observe Event
  
  def after_save(event)
    expire_cache(event)
  end
  
  def after_destroy(event)
    expire_cache(event)
  end
  
  def expire_cache(event)
  end

end