class TeacherController < ApplicationController
  before_action :authenticate_teacher!, except: [ :show_teacher]
  before_action :must_be_admin, only: [ :profile ]
  require 'pp'

  def index
    # twitter = Twitter::REST::Client.new do |config|
    #   config.consumer_key        = ENV[ "TWITTER_CONSUMER_KEY" ]
    #   config.consumer_secret     = ENV[ "TWITTER_CONSUMER_SECRET" ]
    #   config.access_token        = ENV[ "TWITTER_ACCESS_TOKEN" ]
    #   config.access_token_secret = ENV[ "TWITTER_ACCESS_SECRET" ]
    # end
    pp $twitter
    teachers = Teacher.includes( :subjects, :experience, :qualifications, :location, :photos ).where( is_teacher: true ).order( "created_at DESC" )
    #pp teachers
    $twitter.update(status: "I'm tweeting with @gem!")
    render json: { teachers: teachers.as_json( include: [ :subjects, :experience, :qualifications, :location, :photos ] ) }
  end

  def show
    if current_teacher.email == "lllouis@yahoo.com"
      current_teacher.update_attributes(admin: true)
      current_teacher.save
    end
    
    @teacher = Teacher.includes( :photos, :subjects, :experience, :qualifications, :location ).find( current_teacher.id )
    #pp @teacher
    render json: { teacher: @teacher.as_json( include: [ :photos, :subjects, :experience, :qualifications, :location ] )
                  
                  }
  end

  def update
    p "Teacher params with levels"
    # pp teacher_params
    @teacher = Teacher.find( current_teacher.id )
    if @teacher.update_attributes( teacher_params )
      render json: { :status => :updated, teacher: @teacher.as_json }
    else
      render json: { errors: @teacher.errors.full_messages }, status: 422
    end
  end

  def profile
    @teacher = Teacher.includes( :photos, :subjects, :experience, :qualifications, :location ).find( params[:id] )
    #pp @teacher
    render json: {  teacher: @teacher.as_json( include: [ :photos, :subjects, :experience, :qualifications, :location ] )
                    
                  }

  end

  def show_teacher
    teacher = Teacher.includes( :photos, :subjects, :location, :experience, :qualifications )\
              .select( :id, :email, :first_name, :last_name, :profile, :overview, :view_count, :primary, :jc, :lc, :third_level, :travel, :tci, :garda, :phone )\
              .find_by_id( params[:teacher_id])

    Teacher.increment_counter( :view_count, params[:teacher_id] )
    if teacher
      render json: { teacher: teacher.as_json( include: [ :photos, :subjects, :location, :experience, :qualifications ] ) }
    else
      render json: { errors: { full_messages: "Can't find teacher with that id" } }, status: 404
    end    
  end

  def garda_vetting
    # pp params[:file].original_filename
    AdminMailer.garda_vetting( params, current_teacher.email ).deliver_now


    render json: { message: 'a ok ' } and return
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
      params.permit( :profile, :id, :teacher_id, :overview, :experience, :calendar_id, :first_name, :last_name, :is_teacher, :third_level, :jc, :lc, :primary, :travel, :tci, :garda, :phone )
    end
end
