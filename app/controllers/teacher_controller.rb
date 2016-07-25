class TeacherController < ApplicationController
  before_action :authenticate_teacher!
  require 'pp'
  def get
    
    @teacher = Teacher.includes( :photos, :subjects, :experience, :qualifications, :location ).find( current_teacher.id )
    pp @teacher
    render json: { 
                    teacher: @teacher.as_json, 
                    photos: @teacher.photos.as_json, 
                    subjects: @teacher.subjects.as_json, 
                    experience: @teacher.experience,
                    qualifications: @teacher.qualifications.as_json,
                    location: @teacher.location.as_json
                  }
  end

  def update
    @teacher = Teacher.find( params[:id] )
    @teacher.update_attributes( teacher_params )
    render json: { :status => :updated, teacher: @teacher.as_json }
  end

  def profile
    @teacher = Teacher.includes( :photos, :subjects, :experience, :qualifications, :location ).find( params[:id] )
    pp @teacher
    render json: { 
                    teacher: @teacher.as_json, 
                    photos: @teacher.photos.as_json, 
                    subjects: @teacher.subjects.as_json, 
                    experience: @teacher.experience.as_json,
                    qualifications: @teacher.qualifications.as_json,
                    location: @teacher.location.as_json
                  }

  end

  def show_teacher
    teacher = Teacher.includes( :photos, :subjects, :location, :experience, :qualifications )\
              .select( :id, :email, :first_name, :last_name, :profile, :overview )\
              .find( params[:teacher_id])
    render json: { teacher: teacher.as_json( include: [ :photos, :subjects, :location, :experience, :qualifications ] ) }
  end

  def chunks
    render json: 'ok'
  end

  

  private
    

    def teacher_params
      params.permit( :profile, :id, :overview, :experience, :calendar_id )
    end
end