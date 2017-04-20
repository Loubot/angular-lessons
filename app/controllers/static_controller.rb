class StaticController < ApplicationController
  def welcome

  end

  def index
    render layout: 'application'
  end

  def contact_us

    if Rails.env.production?
      m = TeacherMailer.delay.feedback( message_params )
    else
      m = TeacherMailer.feedback( message_params ).deliver_now
    end

    
    
    render json: { message: "Sent ok" }, status: 200
  end

  def robots
    respond_to :text
    expires_in 6.hours, public: true
  end

  private
    def message_params
      params.permit( :text, :name, :email )
    end
end
