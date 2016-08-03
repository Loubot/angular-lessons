class SearchController < ApplicationController
  include SearchHelper
  require 'pp'
  def search
    p "search controller"
    
    teachers = search_query( search_params )
    
    render json: { teachers: teachers }
  end

  def search_subjects
    p search_params
    p "search subjects controller"  
    subjects = Subject.where( "name ILIKE ?", "%#{ search_params[:name] }%" ).select([ :name, :id ])
    pp subjects
    render json: { subjects: subjects }
  end


  private

    def search_params
      params.permit( :subject_name, :county )
    end




end