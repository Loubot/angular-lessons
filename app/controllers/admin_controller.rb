  class AdminController < ApplicationController
  before_action :authenticate_teacher!
  before_action :check_admin

  def tweet
    require './lib/image.rb' 
    teacher = Teacher.find( tweet_params[ :tweet ][ :id ] )

    
    if teacher.profile == nil
      image_id = $client.upload( Twitter::Image.open_from_url("https://s3-eu-west-1.amazonaws.com/angular-lessons/static_assets/facebook_logo.jpg")  )
      x = $client.update( tweet_params[ :tweet ][ :text ], image_id )
    else
      if Rails.env.development?
        image = Twitter::Image.open_from_url( Teacher.last.photos.last.avatar.file.file )
      else
        image = Twitter::Image.open_from_url( Photo.find( teacher.profile ).avatar.url )        
      end
       

      image_id = $client.upload( image )

      pp "Image_id #{ image_id }"
      
      x = $client.update( tweet_params[ :tweet ][ :text ], media_ids: image_id )
      

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