class ConversationController < ApplicationController
  include ConversationHelper

  def create
    p "con params #{ conversation_params }"
    teacher = Teacher.find_by( email: conversation_params[:conversation][:teacher_email] )
    conversation = Conversation.find_or_create_by( 
      teacher_email: teacher.email,
      student_email: conversation_params[:conversation][:student_email]

    )

    p "got conversation"
    pp conversation.id
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

    conversation = Conversation.where( id: conversation.id ).includes( :messages ).first

    render json: { conversation: conversation.as_json( include: [ :messages ] ) }
  end

  def index
    p params
    if ( index_params.has_key?( :teacher_email ) && index_params[ :teacher_email ] != "" )\
      && ( index_params.has_key?( :student_email ) && index_params[:student_email ] != "" )
      conversation = Conversation.where( teacher_email: index_params[ :teacher_email ], student_email: index_params[ :student_email ] ).includes( :messages ).first

      render json: { conversation: conversation.as_json( include: [ :messages ] ) }

    elsif index_params.has_key?( :conversation_id ) && index_params[ :conversation_id ] != ""
      conversation = Conversation.find( index_params[ :conversation_id ] ).includes( :messages )

      render json: { conversation: conversation.as_json( include: [ :messages ] ) }

    elsif index_params.has_key?( :teacher_email ) && index_params[ :teacher_email ] != ""
      conversations = Conversation.where( teacher_email: index_params[ :teacher_email ] ).includes( :messages )
      render json: { conversations: conversations.as_json( include: [ :messages ] ) }
    elsif index_params.has_key?( :random ) && index_params[ :random ] != ""
      conversation = Conversation.where( random: index_params[ :random ] ).includes( :messages ).first
      render json: { conversation: conversation.as_json( include: [ :messages ] ) }

    else
      render json: { error: "Not found"}, status: 404
    end
    #   conversation = Conversation.where( student_email: index_params[:student_email] ).includes( :messages ).order( "messages.created_at" )
    #   render json: { conversation: conversation.first.as_json( include: [ :messages ] ) }
    # elsif index_params.has_key?(:random)
    #   conversation = Conversation.find_by( random: index_params[ :random ] )
    #   render json: { conversation: conversation.as_json }
    # else
    #   conversations = Conversation.includes(:messages).where( teacher_email: params[ :teacher_email ]).order(:created_at).limit( 10 )

    #   render json: { conversations: conversations.as_json( include: [ :messages ] ) }
    # end
    

  end


  private
    def conversation_params
      params.permit( { conversation: [ :name, :phone, :email, :teacher_email, :teacher_id, :message, :student_email ] }, :teacher_id )
      # params.permit( :name, :phone, :email, :teacher_id )

    end

    def index_params
      params.permit( :teacher_email, :student_email, :conversation_id, :random )
    end

end