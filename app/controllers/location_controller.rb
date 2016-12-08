class LocationController < ApplicationController
  before_action :authenticate_teacher!

  def create
    p "This is create"
    pp location_params
    location = Location.new( location_params )
    if location.save
      render json: { location: location.as_json }, status: 201
    else
      render json: { errors: location.errors }, status: 422
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

  def update
    pp params
    teacher = Teacher.includes( :location ).find( current_teacher.id )
    
    if !teacher.location
      p "we are here #{ location_params[ :county ] }"
      location = Location.create!( location_params )
      render json: { errors: location.errors } and return
      
    end

    if params.has_key?( :google )
      if teacher.location.google_address( params )
        render json: { location: teacher.location.as_json }, status: 200
      else
        render json: { errors: teacher.location.errors }, status: 422
      end
    else
      if teacher.location.update_attributes( location_params )
        pp teacher.location
        render json: { location: teacher.location.as_json }, status: 200
      else
        render json: { errors: teacher.location.errors }, status: 422
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
      params.permit( :address, :latitude, :longitude, :teacher_id, :name, :county  )
    end
end