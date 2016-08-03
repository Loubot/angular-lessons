class ConversationController < ApplicationController
  include ConversationHelper

  def create
    p "con params #{ conversation_params }"
    teacher = Teacher.find( conversation_params[:teacher_id] )
    conversation = Conversation.find_or_create_by( 
      teacher_email: teacher.email,
      student_email: conversation_params[:conversation][:email]

    )    
    ConversationMailer.send_message( 
      conversation_params, 
      teacher.email,
      format_url( conversation.random, conversation.id ) 
    ).deliver_now

    conversation.messages.create(
      message:          params[:conversation][:message],
      sender_email:     params[:conversation][:email],
      conversation_id:  conversation.id
    )
    render json: { conversation: conversation.as_json }
  end

  def index
    p params
    if index_params.has_key?(:selected_conversation)
      conversation = Conversation.where( student_email: index_params[:student_email] ).includes( :messages ).order( "messages.created_at" )
      render json: { conversation: conversation.first.as_json( include: [ :messages ] ) }
    else
      conversations = Conversation.includes(:messages).where( teacher_email: params[ :teacher_email ]).order(:created_at).limit( 10 )

      render json: { conversations: conversations.as_json( include: [ :messages ] ) }
    end
    

  end


  private
    def conversation_params
      params.permit( { conversation: [ :name, :phone, :email, :teacher_id, :message ] }, :teacher_id )
      # params.permit( :name, :phone, :email, :teacher_id )

    end

    def index_params
      params.permit( :student_email, :selected_conversation )
    end

end