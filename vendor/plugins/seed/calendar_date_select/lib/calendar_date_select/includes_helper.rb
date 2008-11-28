class CalendarDateSelect
  module IncludesHelper
    
    def asset_path(type)
      "/plugin_assets/calendar_date_select/#{type}/calendar_date_select/"
    end
    
    def calendar_date_select_stylesheets(options = {})
      options.assert_valid_keys(:style, :format, :locale)
      
      style = options[:style]
      cds_css_file = style ? asset_path('stylesheets') + "/#{style}" : asset_path('stylesheets') + "/default"
      return cds_css_file
    end

    def calendar_date_select_javascripts(options = {})
      options.assert_valid_keys(:style, :format, :locale)
      
      style = options[:style]
      locale = options[:locale]
      cds_css_file = style ? asset_path('javascripts') + "/#{style}" : asset_path('javascripts') + "/default"
      
      output = []
      output << "#{asset_path('javascripts')}/calendar_date_select"
      output << "#{asset_path('javascripts')}/locale/#{locale}" if locale
      output << CalendarDateSelect.javascript_format_include if CalendarDateSelect.javascript_format_include
      return output
    end

    def calendar_date_select_includes(*args)
      return "" if @cds_already_included
      @cds_already_included=true
      
      options = (Hash === args.last) ? args.pop : {}
      options.assert_valid_keys(:style, :format, :locale)
      options[:style] ||= args.shift

      js = javascript_include_tag(*calendar_date_select_javascripts(options))
      css = stylesheet_link_tag(*calendar_date_select_stylesheets(options))
      "#{js}\n#{css}\n"
    end
  end
end
