class PhotosController < ApplicationController
  before_action :authenticate_teacher!

  def create
    p "Params #{ pic_params[:avatar] }"
    render json: { message: 'No params' }, status: 400 and return if pic_params[:avatar] == "null"
    @teacher = Teacher.find( current_teacher.id )
    @photo = @teacher.photos.build( pic_params )
    if @teacher.profile == nil

      
      @teacher.save
      p "Made it here"
      p @photo.id
      @teacher.update_attributes( profile: @photo.id )
      render json: { :status => :updated, photos: @teacher.photos, teacher: @teacher }
    else
      @teacher.save
      render json: { photos: @teacher.photos }
    end
    
  end

  def destroy
    photo = Photo.find( pic_params[ :id ] )
    if photo.destroy
      teacher = Teacher.includes( :photos ).find( current_teacher.id )
      if Integer( teacher.profile ) == Integer( pic_params[ :id ] )
        p "Update teacher profile"
        teacher.update_attributes( profile: nil )
      end
      render json: { teacher: teacher.as_json( include: [ :photos ] ) }
    else
      render json: { error: "Failed to destroy photo" }, status: 500
    end
  end

  private
    def pic_params
      params.permit( :photo, :avatar, :id )
    end
end