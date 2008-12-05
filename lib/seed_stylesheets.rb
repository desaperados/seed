module ActionView
  module Helpers
    
    module AssetTagHelper
      
      require 'find'
      
      def seed_includes
        css = stylesheet_link_tag(discover_stylesheets)
        js = javascript_include_tag('prototype', 'scriptaculous', 'effects', 'dragdrop', 'prototip', 'application')
        "#{css}\n#{js}"
      end
      
      def discover_stylesheets
        seed_css = ["seed", "lightview", "prototip"]
        
        engine_css = []
        engine_css_paths = match("#{RAILS_ROOT}/public/plugin_assets/#{APP_CONFIG[:app_name]}_engine/stylesheets/") { |p| ext = p[-4...p.size]; ext && ext.downcase == ".css"}
        engine_css_paths.each { |f| engine_css << seed_stylesheet_link_path(f[/\w+.css\b/])}
      
        seed_css << "default" unless engine_css.find { |x| x =~ /default.css/}
        
        seed_css.concat(engine_css).flatten
        
      end
      
      private
      
      def match(*paths)
        matched = []
        Find::find(*paths) { |path| matched << path if yield path }
        return matched
      end
      
      def seed_stylesheet_link_path(filename)
        "/plugin_assets/#{APP_CONFIG[:app_name]}_engine/stylesheets/#{filename}"
      end
      
    end
    
  end
end