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
    @teacher = Teacher.includes( :photos, :subjects, :experiences, :qualifications ).find( params[:id] )
    pp @teacher
    render json: { 
                    teacher: @teacher, 
                    photos: @teacher.photos, 
                    subjects: @teacher.subjects, 
                    experiences: @teacher.experiences,
                    qualifications: @teacher.qualifications
                  }

  end

  def chunks
    render json: 'ok'
  end

  

  private
    

    def teacher_params
      params.permit( :profile, :id, :overview, :experience, :calendar_id )
    end
end