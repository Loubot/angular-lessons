class TeacherController < ApplicationController
  before_action :authenticate_teacher!
  require 'pp'
  def get
    
    @teacher = Teacher.includes( :photos, :subjects, :experiences, :qualifications, :location ).find( current_teacher.id )
    pp @teacher
    render json: { 
                    teacher: @teacher, 
                    photos: @teacher.photos, 
                    subjects: @teacher.subjects, 
                    experiences: @teacher.experiences,
                    qualifications: @teacher.qualifications,
                    location: @teacher.location
                  }
  end

  def update
    @teacher = Teacher.find( params[:id] )
    @teacher.update_attributes( teacher_params )
    render json: { :status => :updated, teacher: @teacher }
  end

  def profile
    @teacher = Teacher.includes( :photos, :subjects, :experiences, :qualifications, :location ).find( params[:id] )
    pp @teacher
    render json: { 
                    teacher: @teacher, 
                    photos: @teacher.photos, 
                    subjects: @teacher.subjects, 
                    experiences: @teacher.experiences,
                    qualifications: @teacher.qualifications,
                    location: @teacher.location
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