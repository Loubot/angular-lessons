# This file is used by Rack-based servers to start the application.
require 'rack-zippy'
asset_root = '/public/assets'
use Rack::Zippy::AssetServer, asset_root
require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
