class ConversationController < ApplicationController
  include ConversationHelper
  require 'pp'
  before_action :authenticate_teacher!

  def create
    p "!!!!!!!!!!!!!!!!!!!!!!!!!"
    pp conversation_params
    convesation = Conversation.create!( conversation_params[ :conversation ] )

    render status: 200, nothing: true and return
    # if Rails.env.production?
    #   delivered = ConversationMailer.delay.send_message( 
    #     conversation_params, 
    #     sender_email,
    #     format_url( conversation.random, conversation.id ) 
    #   )

    #   ConversationMailer.delay.send_message_copy(
    #     conversation_params,
    #     current_teacher.email
    #   )
    # else
    #   delivered = ConversationMailer.send_message( 
    #     conversation_params, 
    #     sender_email,
    #     format_url( conversation.random, conversation.id ) 
    #   ).deliver_now

    #   ConversationMailer.send_message_copy(
    #     conversation_params,
    #     current_teacher.email
    #   ).deliver_now
    # end

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
    conversations = Conversation.where( user_id1: current_teacher.id, user_id2: current_teacher.id )
    render json: { conversations: conversations.as_json }
  end

  def show
    if current_teacher
      conversation = Conversation.includes( :messages ).find( conversation_params[ :id ] )
      
      render json: { conversation: conversation.as_json( include: [ :messages ] ) }
    else
      render json: { errors: [ 'tut tut' ] }, status: 401
    end
    
  end


  private
    def conversation_params
      params.permit(  { conversation: [ :user_id1, :user_id2, :user_email1, :user_email2, :user_name1, :user_name2 ] },
                      { message: [ :text ] }
                   )
      # params.permit( :name, :phone, :email, :teacher_id )

    end

    def index_params
      params.permit( :teacher_email, :student_email, :conversation_id, :random )
    end

end