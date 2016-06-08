class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    params.delete(:registration)
    p params[:registration]
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :password, :confirm_success_url, :registration])
  end
  protect_from_forgery with: :exception
end
