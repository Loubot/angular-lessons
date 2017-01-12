class AdminMailer < ActionMailer::Base

  def send_message_to_boss( params )

    p "Got here "
    pp params
    
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = { 
                  subject: "Message from About page",
                  :to=>[  
                   {  
                     :email=> params[ :email ]
                     # :name=> "#{student_name}"  
                   }  
                 ],
                :from_email=> "About@learnyourlesson.ie",
                html:
                  "#{ params[ :name ] } wrote: <br> #{ params[ :text ] } <br> email: #{ params[ :user_email ] }"

                }
      async = false
      result = mandrill.messages.send message, async
      # sending = m.messages.send message  
      puts result
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end
  end


end