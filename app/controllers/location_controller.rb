class LocationController < ApplicationController
  before_action :authenticate_teacher!

  def create
    teacher = Teacher.find( current_teacher.id )
    if teacher.location.nil?
      location = Location.create( location_params )
      if location.save
        teacher.location = location
        p "Location created"
        pp location
        render json: { location: location }
      else
        render json: { error: location.errors.full_messages }, status: 500
      end
    else
      location = teacher.location.update_attributes( location_params )
      p "Location updated"
      pp location
      render json: { location: location }
    end
  end


  private

    def location_params
      params.permit( :address, :latitude, :longitude, :teacher_id, :name )
    end
end