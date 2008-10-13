# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  # Skip frameworks you're not going to use. 
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  config.gem 'mislav-will_paginate', :version => '~> 2.3.2', :lib => 'will_paginate', 
      :source => 'http://gems.github.com'

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_seed_session',
    :secret      => '70974e63857c8417f13ed8547170663f3a2efce6e42ad2dc760ce6a794b75a6e8dea0e45b43dd0c14f493be4560595b15267bed26742e22c25af42b0c3d7d9af'
  }

  config.action_controller.session_store = :active_record_store

  # Activate observers that should always be running
  config.active_record.observers = :user_observer
  
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
end

# Add the template directory to the default rails render path
ActionController::Base.prepend_view_path('template')

require 'seed_stylesheets'

