class ConversationMailer < ActionMailer::Base

  def send_message( to, from, params, url )
    phone = params[ :conversation ][ :phone ] ? params[ :conversation ][ :phone ] : "Not provided by student"
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "internal_message_to_teacher"
      template_content = []
      message = { 
                      
                  :to=>[  
                   {  
                     :email=> to[ :email ]
                     # :name=> "#{student_name}"  
                   }  
                 ],
                :from_email=> "LYL@learnyourlesson.ie",
                "merge_vars"=>[
                              { "rcpt"   =>  to[ :email ],
                                "vars" =>  [
                                          { "name"=>"MESSAGE",          "content"=>params[ :message ][ :text ] },
                                          { "name"=>"PHONE",            "content"=>phone },                                        
                                          { "name"=>"NAME",             "content"=>from[ :name ] },
                                          { "name"=>"URL",              "content"=>url }                                      
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

    logger.info "Mail sent to #{ params[ :conversation ][ :user_email2 ] }"

  end

  def send_message_copy( to, from, params, email )
    phone = params[ :conversation ][ :phone ] ? params[ :conversation ][ :phone ] : "Not provided by student"
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "internal_message_to_student"
      template_content = []
      message = { 
                      
                  :to=>[  
                   {  
                     :email=> from[ :email ]
                     # :name=> "#{student_name}"  
                   }  
                 ],
                :from_email=> "LYL@learnyourlesson.ie",
                "merge_vars"=>[
                              { "rcpt"   =>  email,
                                "vars" =>  [
                                          { "name"=>"MESSAGE",          "content"=>params[ :message ][ :text ]  },
                                          { "name"=>"PHONE",            "content"=>phone  },                                      
                                          { "name"=>"NAME",             "content"=>from[ :name ] }                                 
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