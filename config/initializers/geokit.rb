Geokit::Geocoders::GoogleGeocoder.api_key = ENV['GOOGLE_GEO_KEY']

Geokit::Geocoders::ssl_verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?


# Geocoder.configure(
#   :language     => :en,
#   :use_https    => Rails.env.production?, 
#   :api_key      => 'AIzaSyBpOd04XM28WtAk1LcJyhlQzNW6P6OT2Q0',
#   :units        => :km,
# )