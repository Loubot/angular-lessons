# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.2'
# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.paths << Rails.root.join("vendor","assets","bower_components")
Rails.application.config.assets.paths << Rails.root.join("vendor","assets","angular_app")
Rails.application.config.assets.paths << Rails.root.join("app","javascripts","controllers")
Rails.application.config.assets.paths << Rails.root.join("app","javascripts","views")

Rails.application.config.assets.precompile += %w( \vendor\assets\bower_components\angular-material\angular-material.min.css )

Rails.application.configure do
  # Use environment names or environment variables:
  # break unless Rails.env.production? 
  # break unless ENV['ENABLE_COMPRESSION'] == '1'
  
  # Strip all comments from JavaScript files, even copyright notices.
  # By doing so, you are legally required to acknowledge
  # the use of the software somewhere in your Web site or app:
  uglifier = Uglifier.new output: { comments: :none }

  # To keep all comments instead or only keep copyright notices (the default):
  # uglifier = Uglifier.new output: { comments: :all }
  # uglifier = Uglifier.new output: { comments: :copyright }

  config.assets.compile = true
  config.assets.debug = true if Rails.env.development?

  config.assets.js_compressor = uglifier
  config.assets.css_compressor = :sass

  config.middleware.use Rack::Deflater
  config.middleware.insert_before ActionDispatch::Static, Rack::Deflater
  
  # config.middleware.use HtmlCompressor::Rack,
  #   compress_css: true,
  #   compress_javascript: true,
  #   css_compressor: Sass,
  #   enabled: true,
  #   javascript_compressor: uglifier,
  #   preserve_line_breaks: false
    # remove_comments: true,
    # remove_form_attributes: false,
    # remove_http_protocol: false,
    # remove_https_protocol: false,
    # remove_input_attributes: true,
    # remove_intertag_spaces: false,
    # remove_javascript_protocol: true,
    # remove_link_attributes: true,
    # remove_multi_spaces: true,
    # remove_quotes: true,
    # remove_script_attributes: true,
    # remove_style_attributes: true,
    # simple_boolean_attributes: true,
    # simple_doctype: false
end