module ConversationHelper

  def format_url( number, id)
    p "url #{ request.base_url }/#/a/g"

    "#{ request.base_url }/#/conversation/#{ number }/#{ id }"
  end

end