class AdminMailer < ActionMailer::Base

  def send_message_to_boss( params )

    p "Got here "
    pp params
    return
    # begin
    #   require 'mandrill'
    #   m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
    #   template_content = []
    #   message = { 

    #               :to=>[  
    #                {  
    #                  :email=> params[ :email ]
    #                  # :name=> "#{student_name}"  
    #                }  
    #              ],
    #             :from_email=> "LYL@learnyourlesson.ie",
    #             "merge_vars"=>[
    #                           { "rcpt"   =>  to[ :email ],
    #                             "vars" =>  [
    #                                       { "name"=>"MESSAGE",          "content"=>params[ :message ][ :text ] },
    #                                       { "name"=>"PHONE",            "content"=>phone },                                        
    #                                       { "name"=>"NAME",             "content"=>from[ :name ] },
    #                                       { "name"=>"URL",              "content"=>url }                                      
    #                                     ]
    #                       }],

    #             }
    #   async = false
    #   result = mandrill.messages.send_template template_name, template_content, message, async
    #   # sending = m.messages.send message  
    #   puts result
    # rescue Mandrill::Error => e
    #     # Mandrill errors are thrown as exceptions
    #     logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
    #     # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    # raise
    # end
  end


end