class PageSweeper < ActionController::Caching::Sweeper
  observe Page
  
  def after_save(page)
    expire_cache
  end
  
  def after_destroy(page)
    expire_cache
  end
  
  def expire_cache
    # We no longer cache the menu due to differing view
    # permissions. This is obsolete
    # TODO - cache the menu based on view permissions
    expire_fragment 'primary_menu'
    expire_fragment 'secondary_menu'
     
    # expire all pages
    # TODO - use a regex for this rather than going to the database
    Page.find(:all, :select => "id, name").each do |p|
      expire_page(p)
    end 
    
    # expire all events pages with a regex
    expire_fragment(%r{page-*}) 
  end
  
  private
  
  def expire_page(page)
    expire_action(page.to_param)
    expire_action(page.id)
  end

end
