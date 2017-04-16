class SearchController < ApplicationController
  include SearchHelper
  require 'pp'

  def search
    p "search controller"
    
    begin
      teachers = search_query( search_params )
     
      render json: { teachers: teachers }
    rescue Geokit::Geocoders::GeocodeError
      render json: { errors: "Gecoder failed" }, status: 500
    end
  end
    
    
  def search_with_offset
    teachers = []
    subjects = Subject.includes( :teachers ).where( "NAME #{ ilike } ?", "%#{ params[ :subject_name ] }%").select( [ :name, :id ] )
    subjects.all.each do |s| 
      s.teachers.where( is_teacher: true ).includes( :photos, :location, :subjects ).limit( ENV[' TEACHER_LIMIT' ] ).offset( params[ :offset ] ).order('id DESC').all.each do |t|
        teachers << t
      end
    end
    teachers = teachers.as_json(include: [ :photos, :location, :subjects ]).uniq
    
    render json: { teachers: teachers }
  end
    
  

  def search_subjects
    p search_params
    p "search subjects controller"

    if Rails.env.development?
      subjects = Subject.where( "name LIKE ?", "%#{ search_params[:name] }%" ).select([ :name, :id ]).order('name ASC')
    else
      subjects = Subject.where( "name ILIKE ?", "%#{ search_params[:name] }%" ).select([ :name, :id ]).order('name ASC')
    end
    
    # pp subjects
    render json: { subjects: subjects }
  end


  private

    def search_params
      params.permit( :subject_name, :county_name, :offset )
    end




end