class TeacherController < ApplicationController
  before_action :authenticate_teacher!

  def get
    
    render json: current_teacher
  end
end