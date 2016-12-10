class QualificationController < ApplicationController
  before_action :authenticate_teacher!

  def create
    qualification = Qualification.create( qualification_params )
    if qualification.save
      teacher = Teacher.includes( :qualifications ).find( current_teacher.id )
      p "Qualification created successfully #{ qualification }"
      render json: { qualifications: teacher.qualifications }
    else
      p "Failed to create qualification #{ qualification.errors.full_messages }"
      render json: { error: qualification.errors.full_messages }, status: 500
    end
  end

  def destroy
    teacher = Teacher.includes( :qualifications ).find( current_teacher.id )
    pp teacher.qualifications
    if teacher.qualifications.exists?
      teacher.qualifications.delete( params[ :id ] )
      render json: { qualifications: teacher.qualifications.as_json }, status: 200
    else
      render json: { errors: "No qualification to delete "  }, status: 404
    end
  end

  private

    def qualification_params
      params.permit( :title, :school, :start, :end_time, :teacher_id )
    end

    def return_date

    end
end