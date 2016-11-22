Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  config.action_mailer.default_url_options = { host: 'http://localhost:3000' }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  uglifier = Uglifier.new output: { comments: :none }

  # To keep all comments instead or only keep copyright notices (the default):
  # uglifier = Uglifier.new output: { comments: :all }
  # uglifier = Uglifier.new output: { comments: :copyright }

   # config.serve_static_files = true

  # config.assets.compress = true

  # config.assets.compile = true

  # config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  config.middleware.use Rack::Deflater
  config.middleware.insert_before ActionDispatch::Static, Rack::Deflater

  # config.middleware.use HtmlCompressor::Rack,
  #   compress_css: true,
  #   css_compressor: Sass,
  #   enabled: true,
  #   compress_javascript: true,
  #   javascript_compressor: uglifier,
  #   preserve_line_breaks: false
  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  # config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  # config.assets.raise_runtime_errors = true

  config.log_level = :debug

  # config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
