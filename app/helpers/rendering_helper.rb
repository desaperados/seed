module RenderingHelper
  
  # Available helpers for easy rendering of elements in template views:
  #
  # Example – Default Seed Layout
  #
  # <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
  #     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  # <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  #     <head>
  #         <title><%= seed_head_title %></title>
  #        <%= seed_head_elements %>
  #     </head>
  #     <body>
  #         <div id="container">
  #             <%= seed_user_bar %>
  #             <%= seed_admin_messages %>
  # 
  #             <div id="head">
  #                 <%= seed_site_search %>
  #                 <%= seed_page_title %>
  #                 <%= seed_page_description %>
  #             </div>
  # 
  #             <%= seed_secondary_menu "horizontal" %>
  # 
  #             <div id="left">
  #                 <%= seed_primary_menu %>
  #             </div>
  # 
  #             <div id="right">
  #                 <%= content_tag(:div, yield, :class => seed_page_class(@page)) %>
  #             </div>
  # 
  #             <div id="foot">
  #                 <strong>Seed</strong> | a Common Sense CMS from The Media Collective
  #             </div>
  # 
  #         </div>
  #     </body>
  # </html>

  # Required. seed_head_elements renders the necessary javascript and css link tags for seed. 
  # Also includes links for any template css documents which are present. seed_head_title will 
  # render the page title if present or default back to the site name. Should be included inside 
  # the html document head element tag.
  #
  def seed_head_elements
    render :partial => "layouts/shared/headlinks"
  end
  
  # The seed_admin_messages tag is required to display flash notices and errors back to 
  # the user for actions such as successful or failed log in, article creation and update, etc. 
  # Styling of these messages can be customised overridding the div#flash-notice, 
  # div#flash-warning, div#flash-error CSS attributes.
  def seed_admin_messages
    "#{flash_messages}"
  end
  
  # Page Elements
  #
  # For displaying current page attributes and links for creating resources on that page. 
  # Each of these tags takes an optional parameter to specify the html tag inside which it 
  # will be contained. If not specified the default will be used.
  # 
  # Display the page title if present. This displays only the page title as opposed to 
  # seed_head_title which includes the name of the site etc. Displayed inside a h1 tag by 
  # default. To use an alternative tag just pass an extra parameter seed_page_title "h2"
  #
  def seed_page_title(tag="h1")
    if @page
      content_tag(tag, @page.title)
    else
      content_tag(tag, @page_title || APP_CONFIG[:site_name])
    end
  end
  
  # Self explanatory. Display the page description if present. Defaults to a p tag. To use an 
  # alternative tag just pass the extra parameter seed_page_description "h3"
  def seed_page_description(tag="p")
    content_tag(tag, @page.description) unless !@page
  end
  
  # seed_site_search renders the search input and submit tags and takes two optional 
  # parameters – an id for the containing element and the name of the submit tag. 
  # Defaults to seed_site_search "search", "Search" when called with no parameters.
  #
  def seed_site_search(container="search", submit="Search")
    render :partial => "search/form", :locals => {:container => container, :submit => submit}
  end
  
  # Renders a list of child menu items for the given page
  def seed_flat_child_links(page)
    if !page.flat_child_links.empty?
      render :partial => "layouts/shared/flatmenu", :object => page.flat_child_links
    end
  end
  
  # Renders archive links for sidebar - intended for blog and news pages
  def seed_page_archive(title="Archive")
    render :partial => "layouts/shared/archive", :locals => {:title => title} 
  end
  
  # Pages may have any number of articles, news items or posts associated with them. 
  # To display these on a page use seed_render_all and pass the appropriate collection of data and 
  # an optional id for the containing div
  #
  #  Articles Pages:
  #  <%= seed_render_all @articles, "home" %>
  #
  #  Blog Pages:
  #  <%= seed_render_all @posts %>
  #
  #  News Pages:
  #  <%= seed_render_all @newsitems, "news" %>
  #
  def seed_render_all(collection, container="seed-resources")
    render :partial => "layouts/resource/container", :locals => {:collection => collection, :container => container}
  end
  
  # Will render an unordered list element for logged in users only showing current name 
  # and status with appropriate links. If the user has admin permissions will also show 
  # links to the Users and Roles pages. Default id for this element is seed-user-bar which 
  # has default CSS styling applied. Styles can be overridden in the style-sheet or an alternative 
  # container id passed with seed_user_bar "myid"
  #
  def seed_user_bar(container="seed-user-bar")
    render :partial => "layouts/shared/user_bar", :locals => {:container => container}
  end
  
  
  # Renders a menu for all primary menu pages. 
  # Defaults to vertical orientation within a containing div with class name vertical-menu. 
  #
  #   To render a horizontal menu use seed_primary_menu # {}"horizontal". 
  #
  # In practice there are only subtle differences between 
  # the mark-up for a vertically as opposed to a horizontally rendered menu. Have a look at the 
  # html source to see exactly what is rendered. The default CSS contains styling for both the 
  # default horizontal and vertical rendering options.
  #
  def seed_primary_menu(orientation="vertical", container="vertical-menu")
    container = "horizontal-menu" if orientation == "horizontal"
    render :partial => "layouts/shared/menu_container", 
           :locals => {:orientation => orientation, 
                       :container => container,
                       :sortable_id => "menupages",
                       :type => "primary"}
  end
  
  
  # Renders a menu for all secondary menu pages. 
  # Defaults to vertical orientation within a containing div with class name vertical-menu. 
  #
  #   To render a horizontal menu use seed_secondary_menu "horizontal". 
  #
  # In practice there are only subtle differences between the mark-up for a vertically as 
  # opposed to a horizontally rendered menu. Have a look at the html source to see exactly 
  # what is rendered. The default CSS contains styling for the both default horizontal and 
  # vertical rendering options.
  #
  # NOTE: To use the secondary menu you also need to make sure that enable_secondary_menu 
  # is set to true in config/settings.yml
  #
  def seed_secondary_menu(orientation="vertical", container="vertical-menu")
    if secondary_menu?
      container = "horizontal-menu" if orientation == "horizontal"
      render :partial => "layouts/shared/menu_container", 
             :locals => {:orientation => orientation, 
                         :container => container,
                         :sortable_id => "menupages2",
                         :type => "secondary"}
    end
  end
  
  # In addition to resources pages can also contain components. Components are intended to be 
  # used for small snippets of information which may sometimes be required on a page in the form 
  # of a sidebar or introductory section in addition to the main content.
  #
  # To render components for a given page just include seed_page_components with an optional parameter 
  # for the id or the containing div. The default is ‘components’.
  #
  def seed_page_components(container="component")
    if !@page.components.size.zero?
      render :partial => "components/components", :locals => {:container => container}
    end
  end
  
  
  
end