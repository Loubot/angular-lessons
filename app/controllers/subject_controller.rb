class SubjectController < ApplicationController
  before_action :authenticate_teacher!, only: [ :add_subject ]
  require 'pp'
  


  def create
    subject = Subject.new( create_subject_params )
    if subject.save
      subjects = Category.find( subject.category_id ).subjects.order('name ASC')
      render json: { subjects: subjects.as_json }, status: 201
    else
      render json: { errors: subject.errors }, status: 422
    end
  end

  def update
    subject = Subject.find( params[:id] )
    if subject.update_attributes( create_subject_params )
      render json: { subjects: Subject.all.order('name ASC').as_json }, status: 200
    else
      render json: { errors: subject.errors.as_json }, status: 422
    end
  end


  def destroy

  end

  def index
    # subjects = Subject.all
    if Rails.env.development?
      subjects = Subject.where('name LIKE ?', "%#{ params[:search] }%")
    else
      subjects = Subject.where('name ILIKE ?', "%#{ params[:search] }%")
    end

    # subjects = Subject.all if subjects.length == 0
    #pp subjects
    render json: { subjects: subjects.order('name ASC').as_json }, status: 200
  end

  def add_subject
    # p subject_params[:subject][:id]
    if params[:subject].present?
      subject = Subject.find( subject_params[:subject][:id] )
      teacher = Teacher.find( current_teacher )
      if !teacher.subjects.include?(subject)
        teacher.subjects << subject

        render json: { status: 'updated', teacher: teacher, subjects: teacher.subjects }
      else
        render json: { subjects: teacher.subjects, error: "Subject already added" }, status: 404
      end
      # render json: subject_params[:subject]
    else
      teacher = Teacher.includes(:subjects).find( current_teacher )
      render json: { subjects: teacher.subjects }, status: 404
    end
  end

  def remove_subject
    teacher = Teacher.includes(:subjects).find( current_teacher )
    # subject = Subject.find( subject_params[:subject][:id] )

    teacher.subjects.delete( subject_params[:subject][:id] )

    render json: { subjects: teacher.subjects }
  end

  def missing_subject
    if Rails.env.production?
      AdminMailer.delay.request_subject_mail( params )
    else
      AdminMailer.request_subject_mail( params ).deliver_now
    end
    render json: { message: 'p'}
  end


  private
    def subject_params
      params.permit( teacher: [:name, :id], subject: [:id] )
    end

    def create_subject_params
      params.permit( :category_id, :subject, :name, :email )
    end

end
