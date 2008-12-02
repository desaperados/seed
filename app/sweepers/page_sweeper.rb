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
     
    # expire all pages
    Page.find(:all, :select => "id, name").each do |p|
      expire_page(p)
    end 
  end
  
  private
  
  def expire_page(page)
    expire_action(page.to_param)
    if page.id == 1
      expire_action("1")
    end
  end

end
