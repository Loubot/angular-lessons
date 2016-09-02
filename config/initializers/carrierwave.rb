if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      :provider => 'AWS', # required
      :aws_access_key_id => ENV['LESSONS_BOT_ACCESS_KEY'], # required
      :aws_secret_access_key => ENV['LESSONS_BOT_SECRET_KEY'], # required
      :region => 'eu-west-1'
    }
    config.fog_directory = 'angular-lessons' # required
    config.fog_public = false # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'} #

    
  end
  config.validate_unique_filename = false
  config.validate_filename_format = false
  config.validate_remote_net_url_format = false # this is important
end