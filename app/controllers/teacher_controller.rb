class TeacherController < ApplicationController
  before_action :authenticate_teacher!
  require 'pp'
  def get
    
    render json: current_teacher
  end

  def profile
    @teacher = Teacher.includes(:photos).find( params[:id] )
    pp @teacher
    render json: @teacher

  end

  def profile_pic
    @teacher = Teacher.first
    @photo = @teacher.photos.build( params[:file] )
    @teacher.save
    render json: @teacher.photos
  end
end