class AdminController < ApplicationController
  before_action :authenticate_teacher!
  before_action :check_admin

  def tweet
    require './lib/image.rb' 
    teacher = Teacher.find( tweet_params[ :tweet ][ :id ] )
    if teacher.profile == nil
      x = $client.update_with_media( tweet_params[ :tweet ][ :text ], Twitter::Image.open_from_url("https://s3-eu-west-1.amazonaws.com/angular-lessons/static_assets/facebook_logo.jpg")  )
    else
      
      image = Twitter::Image.open_from_url( Teacher.last.photos.last.avatar.file.file ) 
      pp image
      x = $client.update_with_media( tweet_params[ :tweet ][ :text ], image )
      # if image[ "status" ] == "failure"
      #   x = $client.update_with_media( tweet_params[ :tweet ][ :text ], Twitter::Image.open_from_url("https://s3-eu-west-1.amazonaws.com/angular-lessons/static_assets/facebook_logo.jpg")  )
      # else
      #   x = $client.update_with_media( tweet_params[ :tweet ][ :text ], image )
      # end

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