# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')

Rails::Initializer.run do |config|
  
  config.plugin_paths += ["#{RAILS_ROOT}/vendor/plugins/seed"]

  config.gem 'mislav-will_paginate', :version => '~> 2.3.2', :lib => 'will_paginate', 
      :source => 'http://gems.github.com'

  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_seed_session',
    :secret      => '70974e63857c8417f13ed8547170663f3a2efce6e42ad2dc760ce6a794b75a6e8dea0e45b43dd0c14f493be4560595b15267bed26742e22c25af42b0c3d7d9af'
  }

  config.action_controller.session_store = :active_record_store

  config.active_record.observers = :user_observer
  
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
end

ActionController::Base.prepend_view_path("vendor/plugins/#{APP_CONFIG[:app_name]}_engine/app/views")

require 'seed_stylesheets'
