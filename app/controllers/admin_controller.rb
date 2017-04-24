class AdminController < ApplicationController
  before_action :authenticate_teacher!
  before_action :check_admin

  def tweet
    teacher = Teacher.find( tweet_params[ :tweet ][ :id ] )
    if teacher.profile == nil
      x = $client.update( tweet_params[ :tweet ][ :text ] )
    else
      file = Photo.find( teacher.profile ).avatar.url
      pp file
      x = 'aok'
      # x = $client.update_with_media( tweet_params[ :tweet ][ :text ], file )
    end
    render json: { tweet_response: x }
  end

  private

    def tweet_params
      params.permit( { tweet: [ :text, :id ] } )
    end

    def check_admin
      if !current_teacher.admin
        render json: { error: "tut tut" }, status: 403 and return
      end
    end
end