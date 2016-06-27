class SubjectController < ApplicationController
  before_action :authenticate_teacher!, only: [ :add_subject ]
  require 'pp'
  def index

    # subjects = Subject.all
    subjects = Subject.where('name LIKE ?', "%#{ params[:search] }%")
    pp subjects
    render :json =>
      subjects.to_json
  end

  def add_subject
    p subject_params[:subject][:id]
    if params[:subject].present?
      subject = Subject.find( subject_params[:subject][:id] )
      teacher = Teacher.find( subject_params[:teacher][:id] )
      teacher.subjects << subject

      render json: { status: 'updated', teacher: teacher }
      # render json: subject_params[:subject]
    else
      render json: { error: 'No such subject' }, status: 404
    end
  end


  private
    def subject_params
      params.permit( teacher: [:name, :id], subject: [:id] )
    end

end