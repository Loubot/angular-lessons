class TeacherController < ApplicationController
  before_action :authenticate_teacher!, except: [ :show_teacher]
  before_action :must_be_admin, only: [ :profile ]
  require 'pp'

  def index
    teachers = Teacher.includes( :subjects, :experience, :qualifications, :location ).where( is_teacher: true ).order( "created_at DESC" )
    pp teachers
    render json: { teachers: teachers.as_json( include: [ :subjects, :experience, :qualifications, :location ] ) }
  end

  def show
    
    @teacher = Teacher.includes( :photos, :subjects, :experience, :qualifications, :location ).find( current_teacher.id )
    pp @teacher
    render json: { teacher: @teacher.as_json( include: [ :photos, :subjects, :experience, :qualifications, :location ] )
                  
                  }
  end

  def update
    @teacher = Teacher.find( current_teacher.id )
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
    
    def must_be_admin
      if current_teacher.admin != true
        render json: { errors: [ "You are not an admin" ] }, status: 403
        return false
      else
        return true
      end
    end

    def teacher_params
      params.permit( :profile, :id, :teacher_id, :overview, :experience, :calendar_id, :first_name, :last_name, :is_teacher )
    end
end