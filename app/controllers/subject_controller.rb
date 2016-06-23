class SubjectController < ApplicationController

  def index

    subjects = Subject.all

    render :json =>
      subjects.to_json
  end

end