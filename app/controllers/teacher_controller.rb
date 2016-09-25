class TeacherController < ApplicationController
  before_action :authenticate_teacher!, except: [ :show_teacher]
  require 'pp'
  def show
    
    @teacher = Teacher.includes( :photos, :subjects, :experience, :qualifications, :location ).find( current_teacher.id )
    pp @teacher
    render json: { teacher: @teacher.as_json( include: [ :photos, :subjects, :experience, :qualifications, :location ] )
                  
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
    render json: {  teacher: @teacher.as_json( include: [ :photos, :subjects, :experience, :qualifications, :location ] )
                    
                  }

  end

  def show_teacher
    teacher = Teacher.includes( :photos, :subjects, :location, :experience, :qualifications )\
              .select( :id, :email, :first_name, :last_name, :profile, :overview, :view_count )\
              .find_by_id( params[:teacher_id])

    Teacher.increment_counter( :view_count, params[:teacher_id] )
    if teacher
      render json: { teacher: teacher.as_json( include: [ :photos, :subjects, :location, :experience, :qualifications ] ) }
    else
      render json: { errors: { full_messages: "Can't find teacher with that id" } }, status: 404
    end
    
  end

  def chunks
    render json: 'ok'
  end

  

  private
    

    def teacher_params
      params.permit( :profile, :id, :teacher_id, :overview, :experience, :calendar_id, :first_name, :last_name, :is_teacher )
    end
end