class ConversationController < ApplicationController
  include ConversationHelper
  require 'pp'
  before_action :authenticate_teacher!, except: [ :message_bosses ]
  before_action :check_correct_user, only: [ :create ]

  def create
    pp conversation_params
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
    

    send_to_correct_users( conversation_params, conversation ) #make sure email is sent to correct emails


  end

  def message_bosses
    AdminMailer.send_message_to_boss( boss_params ).deliver_now

    render json: { hello: ' bla'}
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

    def boss_params
      params.permit( :email, :name, :text, :user_email )
    end

    def index_params
      params.permit( :teacher_email, :student_email, :conversation_id, :random )
    end

    def check_correct_user
      render json: { errors: "tut tut "}, status: 403 and return if !( conversation_params[:conversation][:user_id1] == current_teacher.id or conversation_params[:conversation][:user_id2] == current_teacher.id )
    end

    def only_show_to_correct( conversation )
      if conversation.user_id1 == current_teacher.id or conversation.user_id2 == current_teacher.id 
        render json: { conversation: conversation.as_json( include: [ :messages ] ) }
      else
        render json: { errors: [ 'tut tut' ] }, status: 403
      end
    end

end