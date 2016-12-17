class ConversationController < ApplicationController
  include ConversationHelper
  require 'pp'
  before_action :authenticate_teacher!
  before_action :check_correct_user, only: [ :create ]

  def create
    # Person sending email will always be user_email1
    conversation = Conversation.where( user_id1: conversation_params[:conversation][:user_id1], user_id2: conversation_params[:conversation][:user_id2] ).or\
                  ( Conversation.where( user_id1: conversation_params[:conversation][:user_id2], user_id2: conversation_params[:conversation][:user_id1] ) )



    if conversation.blank?
      # new conversation. New and save for error response
      p "New Conversation "
      conversation = Conversation.new( conversation_params[ :conversation ] )
      
      if !conversation.save
        render json: { errors: conversation.errors }, status: 422 and return
      end
    else
      # conversation is a result of where statement so must call .first
      conversation = conversation.first
    end

    pp "Conversation is this"


    pp conversation

    

    

    
    message = Message.new( conversation_id: conversation.id, text: conversation_params[:message][:text], sender_id: conversation_params[ :message ][ :sender_id ] )
    p "message *************"
    pp message

    message.save!

    

    render json: { conversation: conversation.as_json( include: [ :messages ] ) }
    



    if Rails.env.production?
      delivered = ConversationMailer.delay.send_message( 
        conversation_params,
        format_url( conversation.id ) 
      )

      ConversationMailer.delay.send_message_copy(
        conversation_params,
        current_teacher.email
      )
    else
      delivered = ConversationMailer.send_message( 
        conversation_params,
        format_url( conversation.id ) 
      ).deliver_now

      ConversationMailer.send_message_copy(
        conversation_params,
        current_teacher.email
      ).deliver_now
    end



    # p "Deliverd #{ delivered }"


    # message = conversation.messages.create(
    #   message:          params[:conversation][:message],
    #   conversation_id:  conversation.id
    # )
    # message.save!
    # pp message

    # conversation = Conversation.where( id: conversation.id ).includes( :messages ).first

    # render json: { conversation: conversation.as_json( include: [ :messages ] ) }
  end

  def index
    conversations = Conversation.where( user_id1: current_teacher.id ).or( Conversation.where( user_id2: current_teacher.id ) )
    render json: { conversations: conversations.as_json }
  end

  def show
    if current_teacher
      conversation = Conversation.includes( :messages ).find( params[ :id ] )

      only_show_to_correct( conversation )
      
      
    else
      render json: { errors: [ 'tut tut' ] }, status: 401
    end
    
  end


  private
    def conversation_params
      params.permit(  { conversation: [ :user_id1, :user_id2, :user_email1, :user_email2, :user_name1, :user_name2 ] },
                      { message: [ :text, :sender_id ] }
                   )
      # params.permit( :name, :phone, :email, :teacher_id )

    end

    def index_params
      params.permit( :teacher_email, :student_email, :conversation_id, :random )
    end

    def check_correct_user
      p "check_correct_user"
      pp conversation_params
      p current_teacher.id
      p Integer( conversation_params[:conversation][:user_id1] ) == Integer( current_teacher.id )
      p Integer( conversation_params[:conversation][:user_id2] ) != Integer( current_teacher.id )
      render json: { errors: "tut tut "}, status: 403 and return if !( Integer( conversation_params[:conversation][:user_id1] ) == Integer( current_teacher.id )\
                   or Integer( conversation_params[:conversation][:user_id2] ) != Integer( current_teacher.id ) )
    end

    def only_show_to_correct( conversation )
      if conversation.user_id1 == current_teacher.id or conversation.user_id2 == current_teacher.id 
        render json: { conversation: conversation.as_json( include: [ :messages ] ) }
      else
        render json: { errors: [ 'tut tut' ] }, status: 403
      end
    end

end