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
    
    
    
    
  

  def search_subjects
    p search_params
    p "search subjects controller"

    if Rails.env.development?
      subjects = Subject.where( "name LIKE ?", "%#{ search_params[:name] }%" ).select([ :name, :id ])
    else
      subjects = Subject.where( "name ILIKE ?", "%#{ search_params[:name] }%" ).select([ :name, :id ])
    end
    
    # pp subjects
    render json: { subjects: subjects }
  end


  private

    def search_params
      params.permit( :subject_name, :county_name )
    end




end