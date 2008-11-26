class EventSweeper < ActionController::Caching::Sweeper
  observe Event
  
  def after_save(event)
    expire_cache(event)
  end
  
  def after_destroy(event)
    expire_cache(event)
  end
  
  def expire_cache(event)
    expire_action "page-#{event.page.to_param}-events"
    expire_action "page-#{event.page.to_param}-events#{event.date.month}#{event.date.year}"
  end

end