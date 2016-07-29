class ConversationController < ApplicationController
  

  def create
    p "con params #{ conversation_params }"
    teacher = Teacher.find( conversation_params[:teacher_id] )
    conversation = Conversation.find_or_initialize_by( 
      teacher_email: teacher.email,
      student_email: conversation_params[:conversation][:email]

    )
    ConversationMailer.send_message( conversation_params, teacher.email ).deliver_now
    render json: { conversation: conversation.as_json }
  end


  private
    def conversation_params
      params.permit( { conversation: [ :name, :phone, :email, :teacher_id, :message ] }, :teacher_id )
      # params.permit( :name, :phone, :email, :teacher_id )

    end

end