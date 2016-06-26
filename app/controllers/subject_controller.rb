class SubjectController < ApplicationController
  require 'pp'
  def index

    # subjects = Subject.all
    subjects = Subject.where('name LIKE ?', "%#{ params[:search] }%")
    pp subjects
    render :json =>
      subjects.to_json
  end

end