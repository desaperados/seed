require 'fileutils'

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
      puts "Doing Demo Setup"
      Dir['config/examples/*'].each do |source|
        destination = "config/#{File.basename(source)}"
        unless File.exist? destination
          FileUtils.cp(source, destination)
          puts "Generated #{destination}"
        end
      end
  
      # run rake setup tasks
      # system "rake gems:install db:create:all"
      system "rake db:migrate --trace"
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
    
  end
end

Seed.setup!

