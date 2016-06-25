class TeacherController < ApplicationController
  before_action :authenticate_teacher!
  require 'pp'
  def get
    
    render json: current_teacher
  end

  def profile
    @teacher = Teacher.includes(:photos).find( params[:id] )
    pp @teacher
    render json: { teacher: @teacher, photos: @teacher.photos }

  end

  def chunks
    render json: 'ok'
  end

  def profile_pic
    # pp params
    @teacher = Teacher.first
    @photo = @teacher.photos.build( pic_params )
    @teacher.save
    render json: @teacher.photos
  end

  private
    def pic_params
      params.permit(:photo, :avatar, :id)
    end
end