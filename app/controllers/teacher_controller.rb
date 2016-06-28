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
    @teacher = Teacher.includes( :photos, :subjects, :experiences ).find( params[:id] )
    pp @teacher
    render json: { teacher: @teacher, photos: @teacher.photos, subjects: @teacher.subjects, experiences: @teacher.experiences }

  end

  def chunks
    render json: 'ok'
  end

  

  private
    

    def teacher_params
      params.permit( :profile, :id, :experience )
    end
end