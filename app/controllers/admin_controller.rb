class AdminController < ApplicationController
  before_action :authenticate_teacher!
  before_action :check_admin

  def tweet
    teacher = Teacher.find( tweet_params[ :tweet ][ :id ] )
    x = $client.update_with_media( tweet_params[ :tweet ][ :text ], File.new( Photo.find( teacher.profile ).avatar.file.file ) )
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