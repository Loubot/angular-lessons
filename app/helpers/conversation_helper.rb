module ConversationHelper

  def format_url( number, id)
    p "urlssssssssss #{ request.base_url }/#/conversation?#{ number }/#{ id }"

    "#{ request.base_url }/#/conversation/#{ number }/#{ id }"
  end

end