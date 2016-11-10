class StaticController < ApplicationController
  def welcome

  end

  def index
    
  end

  def contact_us
    if Rails.env.production?
      m = TeacherMailer.delay.feedback( message_params )
    else
      m = TeacherMailer.feedback( message_params ).deliver_now
    end
    
    render json: { message: m }, status: 200
  end

  private
    def message_params
      params.permit( :text, :name, :email )
    end
end
