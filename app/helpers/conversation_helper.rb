module ConversationHelper

  #helper to ensure email goes from one user to the other and copies are sent to sender not receiver
  def send_to_correct_users( conversation_params, conversation )
    if conversation_params[ :conversation ][ :user_id1 ] == current_teacher.id
      from = { email: conversation_params[ :conversation ][ :user_email1 ], name: conversation_params[ :conversation ][ :user_name1 ] }
      to   = { email: conversation_params[ :conversation ][ :user_email2 ], name: conversation_params[ :conversation ][ :user_name2 ] }
    else
      from = { email: conversation_params[ :conversation ][ :user_email2 ], name: conversation_params[ :conversation ][ :user_name2 ] }
      to   = { email: conversation_params[ :conversation ][ :user_email1 ], name: conversation_params[ :conversation ][ :user_name1 ] }
    end

    p "From #{ from }"
    p "to #{ to }"

    if Rails.env.production?
      delivered = ConversationMailer.delay.send_message( 
        to,
        from,
        conversation_params,
        format_url( conversation.id ) 
      )

      ConversationMailer.delay.send_message_copy(
        to,
        from,
        conversation_params,
        current_teacher.email
      )
    else
      delivered = ConversationMailer.send_message(
        to,
        from, 
        conversation_params,
        format_url( conversation.id ) 
      ).deliver_now

      ConversationMailer.send_message_copy(
        to,
        from,
        conversation_params,
        current_teacher.email
      ).deliver_now
    end

  end #end of send_to_correct_users

  def format_url( id )
    p "urlssssssssss #{ request.base_url }/#/conversation/#{ id }"

    "#{ request.base_url }/#/conversation/#{ id }"
  end

end