class AdminMailer < ActionMailer::Base


  def garda_vetting( params, email )
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = { 
                  subject: "Garda vetting",
                  :to=>[  
                   {  
                     :email=> "loubot@learnyourlesson.ie"
                     # :name=> "#{student_name}"  
                   }  
                 ],
                :from_email=> "GardaVetting@learnyourlesson.ie",
                html:
                  "#{ email } uploaded their garda vetting",
                :attachments=> [{
                    'content'=> Base64.encode64(params[:file].read),
                    "name"=> params[:file].original_filename
                  }]

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

  def send_message_to_boss( params )
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

  def request_subject_mail( params )
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = { 
                  subject: "Request subject message",
                  :to=>[  
                   {  
                     :email=> "loubot@learnyourlesson.ie"
                     # :name=> "#{student_name}"  
                   }  
                 ],
                :from_email=> "do_not_reply@learnyourlesson.ie",
                html:
                  "#{ params[ :name ] } requested: #{ params[ :subject ] } <br> email: #{ params[ :email ] }"

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