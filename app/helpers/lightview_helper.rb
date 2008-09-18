module LightviewHelper

# A lightview is shown with js like below (example taken from the lightview site: 
# (http://www.nickstakenburg.com/projects/lightview/)
# There are 2 levels of arguments: 
#   top-level 'parameters' (href, rel etc.)
#   2nd-level 'options' (autosize, ajax etc.)

#  Lightview.show({
#    href: '/ajax/',
#    rel: 'ajax',
#    title: 'Login',
#    caption: 'Enter your username and password to login',
#    options: {
#      autosize: true,
#      topclose: true,
#      ajax: {
#        method: 'get',
#        onComplete: function(){ $('name').focus(); }
#      }
#    }
#  });

 # link to a light view.
 # name: the text to display in the link
 # options: url options for the content to show in the lightview
 # html_options: html_options to pass to link_to 
 # lightview_params: parameters (top-level arguments) for lightview, that differ from or add to defaults
 # lightview_options: options (2nd-level arguments) for lightview, that differ from or add to the defaults
 def link_to_lightview( name, options = {}, html_options = {}, lightview_params = {}, lightview_options = {} )

    # get hold of the js for showing the lightview
    show_lightview_js = show_lightview( options, lightview_params, lightview_options )

    # merge in the javascipt on the onclick event, keeping any other onclick code intact.    
    html_options.merge!({ 
      :onclick => (html_options[:onclick] ? "#{html_options[:onclick]}; " : "") + "#{show_lightview_js} return false;" 
    })

    # return a link which points to #, but has the onclick event in the html options.
    link_to( name, "#", html_options )

  end 

  # returns javascript for showing a lightview.
  # url_options : hash of options to pass to url_for 
  # parameters: parameters (top-level arguments) for lightview, that differ from or add to defaults
  # options: options (2nd-level arguments) for lightview, that differ from or add to the defaults
  def show_lightview( url_options, parameters, options = {} )

    # get hold of the default options and merge in what is passed in to this method
    lightview_options = get_default_lightview_options
    lightview_options.merge!( options )

    # get hold of the default parameters
    lightview_params = get_default_lightview_params
    #  merge in any paramters passed in
    lightview_params.merge!(parameters)
    #merge in the href and options(from above)
    lightview_params.merge!( 
      { 
        :href => "'#{escape_javascript(url_for(url_options))}'",
        :options => options_for_javascript(lightview_options)
      }
    )

    # return js to show the lightview 
    "      
      Lightview.show(
        #{options_for_javascript(lightview_params)}   
       );
    "

  end

  # returns js to hide a lightview
  def close_lightview_js
    "Lightview.hide();"
  end

  # appends javsascript to hide a lightview to the page
  def close_lightview_rjs
    page<<close_lightview_js
  end

  private 

  # a default set of parameters for showing a lightview 
  # (top-level arguments -see comments at top of file)
  def get_default_lightview_params
    {
      :rel => "'ajax'",
    }
  end

  # a default set of options for showing a lightview 
  # (2nd-level arguments -see comments at top of file)
  def get_default_lightview_options
    {
       :autosize => true,
       :ajax => options_for_javascript({ :evalScripts => true }) # this is so any js in the displayed page is available (e.g. for autocompleter)
    }
  end

end