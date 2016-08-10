class ConversationMailer < ActionMailer::Base

  def send_message( params, email, url )
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "internal-message"
      template_content = []
      message = { 
                      
                  :to=>[  
                   {  
                     :email=> email
                     # :name=> "#{student_name}"  
                   }  
                 ],
                :from_email=> "LYL@learnyourlesson.ie",
                "merge_vars"=>[
                              { "rcpt"   =>  email,
                                "vars" =>  [
                                          { "name"=>"MESSAGE",          "content"=>params[:conversation][:message]  },
                                          { "name"=>"PHONE",            "content"=>params[:conversation][:phone]  },                                        
                                          { "name"=>"NAME",             "content"=>params[:conversation][:name]  },
                                          { "name"=>"URL",              "content"=>url}                                      
                                        ]
                          }],
                  
                }
      async = false
      result = mandrill.messages.send_template template_name, template_content, message, async
      # sending = m.messages.send message  
      puts result
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end

    logger.info "Mail sent to #{ email }"

  end

end