module RenderingHelper
  
  def seed_page_components(container="component")
    render :partial => "components/components", :locals => {:container => container}
  end
  
  def seed_admin_messages
    "#{flash_messages} #{content_tag(:div, nil, :id => 'ajax-msg')}"
  end
  
  def seed_head_elements
    
  end
  
end