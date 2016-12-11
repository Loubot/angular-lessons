module ConversationHelper

  def format_url( id )
    p "urlssssssssss #{ request.base_url }/#/conversation/#{ id }"

    "#{ request.base_url }/#/conversation/#{ id }"
  end

end