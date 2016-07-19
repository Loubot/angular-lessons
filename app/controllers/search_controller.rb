class SearchController < ApplicationController
  require 'pp'
  def search
    p "search controller"
    subject = Subject.includes(:teachers).where('name LIKE ?', "%#{ params[:name] }%").select( [ :name, :id ] ).first
    pp subject
    teachers = subject.teachers.select( "email, id" )
    render json: { teachers: teachers, subject: subject }
  end

  def search_subjects
    p params
    p "search subjects controller"  
    subjects = Subject.where( "name LIKE ?", "%#{ search_params[:name] }%" ).select([ :name, :id ])
    pp subjects
    render json: { subjects: subjects }
  end


  private

    def search_params
      params.permit( :name, :location, :search )
    end

end