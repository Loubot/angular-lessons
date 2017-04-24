class AdminController < ApplicationController
  before_action :authenticate_teacher!
  before_action :check_admin

  def tweet
    
    teacher = Teacher.find( tweet_params[ :tweet ][ :id ] )
    if teacher.profile == nil
      x = $client.update( tweet_params[ :tweet ][ :text ] )
    else
      require 'open-uri'
      image = Twitter::Image.open_from_url( Photo.find( teacher.profile ).avatar.url ) 
      
      
      x = $client.update_with_media( tweet_params[ :tweet ][ :text ], image )
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