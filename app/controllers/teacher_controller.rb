class TeacherController < ApplicationController
  before_action :authenticate_teacher!
  require 'pp'
  def get
    
    render json: current_teacher
  end

  def update
    @teacher = Teacher.find( params[:id] )
    @teacher.update_attributes( teacher_params )
    render json: { :status => :updated, teacher: @teacher }
  end

  def profile
    @teacher = Teacher.includes(:photos, :subjects).find( params[:id] )
    pp @teacher
    render json: { teacher: @teacher, photos: @teacher.photos, subjects: @teacher.subjects }

  end

  def chunks
    render json: 'ok'
  end

  def profile_pic
    # pp params
    @teacher = Teacher.first
    @photo = @teacher.photos.build( pic_params )
    if @teacher.profile == nil

      
      @teacher.save
      p "Made it here"
      p @photo.id
      @teacher.update_attributes( profile: @photo.id )
      render json: { :status => :updated, photos: @teacher.photos, teacher: @teacher }
    else
      @teacher.save
      render json: { photos: @teacher.photos }
    end
    
  end

  private
    def pic_params
      params.permit(:photo, :avatar, :id)
    end

    def teacher_params
      params.permit( :profile, :id )
    end
end