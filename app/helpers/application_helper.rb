module ApplicationHelper
  
  def format_date(date, use_time = false)
     if use_time == true
         ampm = date.strftime("%p").downcase
         new_date = date.strftime("%A, %B %d %Y at %I:%M" + ampm)
     else
         new_date = date.strftime("%A, %B %d %Y")
     end
  end
  
  def viewable?(page)
    page.public? || (logged_in? && page.private?) || (logged_in? && current_user.has_role?("#{page.viewable_by}"))
  end
  
  def editable?(page)
    (logged_in? && page.all_users?) || (logged_in? && current_user.has_role?("#{page.editable_by}"))
  end
  
  # Convenience methods for checking site settings
  def secondary_menu?
    true unless APP_CONFIG[:enable_secondary_menu] != true
  end
  
  def horizontal_menu?
    true if primary_horizontal? || secondary_horizontal?
  end
  
  def secondary_horizontal?
    true unless APP_CONFIG[:secondary_menu_orientation] != "horizontal"
  end
  
  def primary_horizontal?
    true unless APP_CONFIG[:primary_menu_orientation] != "horizontal"
  end
  
  # Generate RESTful path for the pages menu according
  # to Page attributes
  def resource_path(page)
    eval ("#{page.kind}_path(#{page.id})")
  end
  
  # Generate a link for adding a new resource based on the 
  # controller name
  def add_resource_link(controller, page)
    if controller != "pages" && editable?(page)
      content_tag(:span, 
        link_to("Add #{controller.singularize.capitalize!}", :controller => controller, :action => "new"),
        :class => "seed-admin-tag"
      )
    end
  end
  
  # Javascript include helper for lightview
  def use_lightview
      # Avoid multiple inclusions
      @content_for_lightview_css = "" 
      @content_for_lightview_js = "" 
      content_for :lightview_css do
        stylesheet_link_tag "lightview.css"
      end  
      content_for :lightview_js do
        javascript_include_tag "lightview.js"
      end
  end
  
  # Sets the html head section title
  def head_title
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
  
  # Sets the section title from Page.title if exists, or a title() if
  # passed, else defaults to the site name.
  def page_title
    if @page
      content_tag(:h1, @page.title)
    else
      content_tag(:h1, @page_title || APP_CONFIG[:site_name])
    end
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
