class LocationController < ApplicationController
  before_action :authenticate_teacher!

  def create
    teacher = Teacher.includes(:location).find( location_params[ :teacher_id ] )
    p "location params #{ location_params }"
    
    if teacher.location.nil?
      p "No location!!"
      if location_params.has_key?( :county )
        p "has key county"
        location = Location.geocode_county( location_params, location_params[ :teacher_id ] )
      else
        p "Doesn't have key county"

        location = Location.create( location_params )

      end

      if location.save
        teacher.location = location
        p "Location created"
        pp location
        render json: { location: location.as_json }
      else
        render json: { error: location.errors.full_messages }, status: 500
      end
    else #teacher.location != nil
      p "Yes location !!"
      location = teacher.location.update_attributes( location_params )
      p "Location updated"
      pp location
      render json: { location: teacher.location }
    end
  end

  def manual_address
    teacher = Teacher.includes( :location ).find( current_teacher.id )
    if teacher.location.nil?
      location = Location.manual_address( location_params, current_teacher.id )
      if location.save
        teacher.location = location
        pp location
        render json: { location: location }
      else
        render json: { errors: location.errors.full_messages }, status: 500
      end
    else
      if teacher.location.update_attributes( location_params )
        pp "updated #{ teacher.location }"
        render json: { location: teacher.location.as_json }
      else
        render json: { message: ' no good '}, status: 403
      end
    end

  end

  def destroy
    location = Location.find( params[:id] )
    if location.update_attributes( address: nil )

      render json: { location: location }, status: 200
    else
      render json: { message: 'Failed to delete' }, status: 500
    end
  end


  private

    def location_params
      params.permit( :address, :latitude, :longitude, :teacher_id, :name, :county )
    end
end