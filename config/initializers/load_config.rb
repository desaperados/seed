APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/settings.yml")[RAILS_ENV].symbolize_keys
ExceptionNotifier.exception_recipients = APP_CONFIG[:admin_email]
ExceptionNotifier.email_prefix = "#{APP_CONFIG[:site_name]} ERROR "