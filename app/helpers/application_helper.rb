module ApplicationHelper

  # _roots_ is a collection of root items that will be traversed
  # other params are the same as options_from_collection_for_select
  # _initial_options_ is a collection of options added in front of the result (for the format see options_for_select)
  # If a block is given, _text_method_ is disabled (you may pass nil) and each item will be passed to the block, the returned value will be stringified and be used as the value. This way you may control the indentation string.
  # example to add the ancestors in the options:
  # options_from_tree_for_select(Category.find_all_by_parent_id(nil), :id, nil) {|item, depth| (item.ancestors.reverse << item).map(&:name).join("->") }
  # simply override the indentation padding:
  # options_from_tree_for_select(Category.find_all_by_parent_id(nil), :id, nil) {|item, depth| "---"*depth + item.name }
  def options_from_tree_for_select(roots, value_method, text_method, selected_value = nil, initial_options = nil)
    options_for_select(options_from_tree(roots, value_method, text_method, initial_options), selected_value)
  end

  def options_from_tree(roots, value_method, text_method, initial_options = nil)
    sub_items = lambda {|items, depth| items.inject([]) {|options, item| options << [block_given? ? yield(item, depth).to_s : ("- "*depth + item.send(text_method)), item.send(value_method)]; options += sub_items.call(item.children, depth+1) }}
    (initial_options || []) + sub_items.call(roots, 0)
  end
  
  # Add a path helper for template images
  def template_image_path(source)
    compute_public_path(source, "plugin_assets/#{APP_CONFIG[:app_name]}_engine/images")
  end
  
  def format_date(date, use_time = false)
     if use_time == true
         ampm = date.strftime("%p").downcase
         new_date = date.strftime("%A, %B %d %Y at %I:%M" + ampm)
     else
         new_date = date.strftime("%A, %B %d %Y")
     end
  end
  
  # Display speech marks stripped on save
  def display_speech_marks(content)
    content.gsub(/\[s-mark\]/, '"')
  end
  
  # Remove whitespace when using Redcloth
  def textilize(text)
    if text.blank?
     ""
    else
      RedCloth.new(display_speech_marks(text.lstrip)).to_html
    end
  end
  
  def menu_current?(menu)
    "selected" if menu.id == @page.id unless !@page
  end
  
  def content_tag_if(tag, content, condition)
    content_tag(tag, content) unless !condition
  end
  
  def simple_date(date)
    date.strftime("%B %d, %Y")
  end
  
  def seed_page_class(page)
    if page && action_name != "new"
      "#{page.name.downcase.gsub(" ", "-")}"
    else
      "admin"
    end
  end
  
  def sanitized_class_name(name)
    name.downcase.gsub(" ", "-")
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
    if page.custom_path.nil?
      eval "#{page.kind}_path('#{page.id}-#{page.permalink}')"
    else
      page.custom_path
    end
  end
  
  # Generate a path for component links
  def resource_path(page, resource)
    if page.kind == "articles"
      eval("articles_path('#{page.id}-#{page.permalink}')")
    else
      eval("#{page.kind.singularize}_path('#{page.id}-#{page.permalink}', #{resource})")
    end
  end
  
  def display_page_edit_tags?
    if @page
      true unless params[:controller] == "pages" || params[:controller] == "components" || !editable?(@page)
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
  def title(str, container = nil, options = nil)
    @page_title = str
    content_tag(container, str, options) if container
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
