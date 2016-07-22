class ExperienceController < ApplicationController
  before_action :authenticate_teacher!

  def create
    experience = Experience.find_or_create_by( teacher_id: current_teacher.id )
    experience.update_attributes( experience_params )
    if experience.save
      render json: { experience: experience.as_json }
    end
  end

  def destroy
    teacher = Teacher.includes( :experience ).find( current_teacher.id )
    # experience = Experience.find( params[:id] )
    teacher.experience.delete( experience_params[:id] )
    render json: { experience: teacher.experience.as_json }
  end

  private
    def experience_params
      params.permit( :description, :id, :teacher_id )
    end
end