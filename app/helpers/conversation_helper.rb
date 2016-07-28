module ConversationHelper
  require 'pp'
  

  def booking_message( params )
    begin
      require 'mandrill'
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {"global_merge_vars"=>[{"content"=>"merge1 content", "name"=>"merge1"}],
       "recipient_metadata"=>
          [{"rcpt"=>"recipient.email@example.com", "values"=>{"user_id"=>123456}}],
       "tags"=>["password-resets"],
       "return_path_domain"=>nil,
       "tracking_domain"=>nil,
       "to"=>
          [{"name"=>"Louis",
              "type"=>"to",
              "email"=>"louisangelini@gmail.com"}],
       "text"=>"Example text content",
       "from_name"=>"LYL",
       "subject"=>"Booking request",
       "html"=>"<p>I want a booking_message</p>",
       "from_email"=>"lyl@learnyourlesson.ie",}
      async = false
      ip_pool = "Main Pool"
      send_at = "example send_at"
      result = mandrill.messages.send message, async, ip_pool
          # [{"_id"=>"abc123abc123abc123abc123abc123",
          #     "reject_reason"=>"hard-bounce",
          #     "status"=>"sent",
          #     "email"=>"recipient.email@example.com"}]
      pp result
    rescue Mandrill::Error => e
      # Mandrill errors are thrown as exceptions
      puts "A mandrill error occurred: #{e.class} - #{e.message}"
      # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'
      raise
    end

  end


end