Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :github,        ENV['GITHUB_KEY'],   ENV['GITHUB_SECRET'],   scope: 'email,profile'
  provider :facebook,      ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], callback_url: "http://localhost:3000/omniauth/facebook/callback"  # provider :google_oauth2, ENV['GOOGLE_KEY'],   ENV['GOOGLE_SECRET']

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
end