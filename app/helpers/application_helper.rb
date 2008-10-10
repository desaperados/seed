module ApplicationHelper
  
  def format_date(date, use_time = false)
     if use_time == true
         ampm = date.strftime("%p").downcase
         new_date = date.strftime("%A, %B %d %Y at %I:%M" + ampm)
     else
         new_date = date.strftime("%A, %B %d %Y")
     end
  end
  
  def simple_date(date)
    date.strftime("%B %d %Y")
  end
  
  def tag_id_for_page(page)
    if page && action_name != "new"
      "#{page.name.downcase.gsub(" ", "-")}"
    else
      "admin"
    end
  end
  
  def clean_id(params)
    params.gsub(/-[a-z1-9]+/i, "")
  end
  
  # Convenience methods for checking site settings
  def secondary_menu?
    true unless APP_CONFIG[:enable_secondary_menu] != true
  end
  
  def viewable?(page)
    if page
      page.public? || (logged_in? && page.private?) || (logged_in? && current_user.has_role?("#{page.viewable_by}"))
    end
  end
  
  def editable?(page)
    (logged_in? && page.all_users?) || (logged_in? && current_user.has_role?("#{page.editable_by}"))
  end
  
  # Generate RESTful path for the pages menu according
  # to Page attributes
  def resources_path(page)
    eval "#{page.kind}_path('#{page.id}-#{page.permalink}')"
  end
  
  # Generate a path for component links
  def resource_path(page, resource)
    if page.kind == "articles"
      eval("articles_path('#{page.id}-#{page.permalink}')")
    else
      eval("#{page.kind.singularize}_path('#{page.id}-#{page.permalink}', #{resource})")
    end
  end
  
  # Generate a link for adding a new resource based on the 
  # controller name
  def add_resource_link(controller, page, class_name="seed-admin-tag")
    if controller != "pages" && editable?(page) && controller != "components"
        content_tag(:span, 
        link_to("Add #{controller.singularize.capitalize!}", :controller => controller, :action => "new")+"|"+
        link_to("Add Component", new_component_path), :class => class_name)
    end
  end
  
  # Sets the html head section title
  def seed_head_title
    root = "#{APP_CONFIG[:site_name]} &raquo;"
    title = @page_title || (@page.title if @page) || APP_CONFIG[:site_description]
    "#{root} #{title}"
  end
  
  def boolean_to_string(boolean, truestring, falsestring)
    (boolean == true) ? truestring : falsestring
  end
  
  # Sets a page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end
  
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, flash[msg.to_sym], :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end
  
end
