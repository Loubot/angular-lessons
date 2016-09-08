class Devise::PasswordsController < DeviseTokenAuth::PasswordsController
  require   'uri'
  def render_edit_error
    p "7777777777777777777777777777777"
    redirect_to "#{ root_url }#/#{ URI.encode('Invalid or old token. PLease try again.') }"
  end

  

end