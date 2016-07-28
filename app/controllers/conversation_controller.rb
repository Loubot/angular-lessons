class ConversationController < ApplicationController
  include ConversationHelper
  

  def create
    p "con params #{ conversation_params[:teacher_id] }"
    teacher = Teacher.find( conversation_params[:teacher_id] )
    conversation = Conversation.find_or_initialize_by( 
      teacher_email: teacher.email,
      student_email: conversation_params[:conversation][:email]

    )
    booking_message( conversation_params )
    render json: { conversation: conversation.as_json }
  end


  private
    def conversation_params
      params.permit( { conversation: [ :name, :phone, :email, :teacher_id ] }, :teacher_id )
      # params.permit( :name, :phone, :email, :teacher_id )

    end

end