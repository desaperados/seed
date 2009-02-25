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
    
    # Check for components
    components = Component.find(:all, :conditions => ["source_page = ?", event.page_id])
    components.each do |component|
      expire_component(component)
      expire_page(component)
    end
  end
  
  private
  
  def expire_component(component)
    expire_fragment "component-#{component.id}"
  end
  
  def expire_page(resource)
    expire_action(resource.page.to_param)
    expire_action("#{resource.page_id}")
  end

end