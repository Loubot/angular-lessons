class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    params.delete(:registration)
    params.delete(:config_name)
    params.delete(:confirm_success_url)
    p params[:registration]
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :password, :session, :is_teacher])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name, :password, :session, :is_teacher])
  end
  protect_from_forgery with: :exception
end
