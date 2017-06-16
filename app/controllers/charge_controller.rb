class ChargeController < ApplicationController
  before_action :authenticate_teacher!

  def create
    charge = Charge.find_or_create_by( teacher_id: charge_params[ :teacher_id ] )
    charge.update_attributes( charge_params )

    if charge.save
      render json: { charge: charge.as_json }, status: 200
    else
      render json: { errors: charge.errors }, status: 400
    end

  end

  private

    def charge_params
      params.permit( :teacher_id, :mins, :price )
    end
end