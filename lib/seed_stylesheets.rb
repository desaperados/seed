module ActionView
  module Helpers
    
    module AssetTagHelper
      
      require 'find'
      
      def seed_stylesheets
        seed_css = ["seed"]
        
        template_css = []
        template_css_paths = match("#{RAILS_ROOT}/public/stylesheets/template/") { |p| ext = p[-4...p.size]; ext && ext.downcase == ".css"}
        template_css_paths.each { |f| template_css << seed_stylesheet_link_path(f[/\w+.css\b/])}
      
        seed_css << "default" unless template_css.find { |x| x == "default.css"}
        
        seed_css.concat(template_css).flatten
        
      end
      
      private
      
      def match(*paths)
        matched = []
        Find::find(*paths) { |path| matched << path if yield path }
        return matched
      end
      
      def seed_stylesheet_link_path(filename)
        "/stylesheets/template/#{filename}"
      end
      
    end
    
  end
end