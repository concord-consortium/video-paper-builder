VPB::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # set a host name for emails
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # When true, eager loads all registered config.eager_load_namespaces.
  # This includes your application, engines, Rails frameworks, and any other registered namespace.
  config.eager_load = false

  # whitelist the following domains (needed for rails 6 middleware to prevent against DNS rebinding attacks)
  config.hosts << "vpb-temp.staging.concord.org"
end
