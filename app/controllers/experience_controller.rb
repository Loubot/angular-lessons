class ExperienceController < ApplicationController
  before_action :authenticate_teacher!

  def create
    teacher = Teacher.includes( :experiences ).find( current_teacher.id )
    experience = Experience.create( experience_params )

    teacher.experiences << experience
    teacher.save
    render json: { experiences: teacher.experiences }
  end

  def destroy
    teacher = Teacher.includes( :experiences ).find( current_teacher.id )
    # experience = Experience.find( params[:id] )
    teacher.experiences.delete( experience_params[:id] )
    render json: { experiences: teacher.experiences }
  end

  private
    def experience_params
      params.permit( :title, :description, :id )
    end
end