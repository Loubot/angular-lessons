class SearchController < ApplicationController

  def search
    p "search controller"
    subject = Subject.where('name LIKE ?', "%#{ params[:name] }%").first
    pp subject
    teachers = subject.teachers.select( "email, id" )
    render json: { teachers: teachers, subject: subject }
  end


  private

    def search_params
      params.permit( :name, :location )
    end

end