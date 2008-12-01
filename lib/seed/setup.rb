require 'fileutils'
require 'highline/import'

module Seed
  class << self
    
    def setup!
      operation = ARGV.first
      if ARGV.include?("--force-overwrite")
        overwrite = true
      end
      
      case operation
        when "demo"
          Setup.new.demo
        when "clean"
          puts "Clean setup not yet implemented"
        when "custom"
          puts "Custom setup not yet implemented"
        else
          Setup.new.usage
      end
    end
    
  end
  
  class Setup
    
    def demo
     appname = ask('Enter a name for your application: ')
     sitename = ask('Enter a name for your site: ')
     email = ask('Admin email address: ')
     
      Dir['config/examples/*'].each do |source|
        destination = "config/#{File.basename(source)}"
        unless File.exist? destination
          FileUtils.cp(source, destination)
          puts "Generated #{destination}"
        end
      end
      
      app_plugin = "vendor/plugins/#{appname}_engine"
      unless File.exist? app_plugin
        system "script/generate plugin #{appname}_engine"
        system "mkdir #{app_plugin}/app"
        system "mkdir #{app_plugin}/public"
        system "mkdir #{app_plugin}/public/images"
        system "mkdir #{app_plugin}/public/stylesheets"
      end
  
      # system "rake gems:install db:create:all"
      puts "Setting up database..."
      system "rake db:migrate --trace"
      
      puts "Loading demo data..."
      system "rake db:data:load_demo"
      
      Setup.new.complete(appname)
    end
    
    def usage
      puts <<-usage
  
      ==Seed Setup==
  
      Usage: script/setup [option] [--force-overwrite]
  
        Please specify a valid option:
  
        1. script/setup demo
        The default version of seed with single vertical menu and 
        a selection of pages and content
  
        2. script/setup clean
        A clean setup with no pages or article content
  
        3. script/setup custom
        Custom setup. You will be prompted for options
  
      usage
    end
    
    def complete(appname)
      puts <<-complete
  
      ==Seed Setup Complete for #{appname}==
  
        1. Config files created
        2. Database set-up and migrated
        3. #{appname.downcase}_engine set-up in vendor/plugins/#{appname.downcase}_engine
        
        You can:
         - Override default styles by placing default.css in #{appname.downcase}_engine/public/stylesheets
         - Override views by placing files in #{appname.downcase}_engine/app/views
         - and much more...]
       
        You should now:
         - Customise config/settings.yml to suit your requirements
         - Replace the secret key in config/environment.rb with the new key below:
  
      complete
      puts "New Secret Key: "
      system 'rake secret'
    end
    
  end
end

Seed.setup!

