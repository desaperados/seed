module ApplicationHelper
  
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
  
  # Generate a link for adding a new resource based on the controller
  # name
  def add_resource_link(controller)
    link_to "Add #{controller.singularize.capitalize!}", :controller => controller, :action => "new"
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
  
  # Sets the html head section title
  def head_title
    root = "#{APP_CONFIG[:site_name]} &raquo;"
    title = @page_title || (@page.title if @page) || APP_CONFIG[:site_description]
    "#{root} #{title}"
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
