class TeacherMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts={})
    puts "record: #{record.first_name} token: #{token} opts: #{opts}  #{:reset_password_instructions}"
    p "<a href=#{ opts[:redirect_url] }>Reset password</a></html>)"
    @token = token    
    #devise_mail(record, :reset_password_instructions, opts)
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "Password reset",  
       :from_name=> "Learn Your Lesson",  
       :text=> %Q(<html>Reset your password  <br>

                <a href='#{ opts[:redirect_url] }'>Reset password</a></html>), 
       :to=>[  
         {  
           :email=> record.email,
           :name=> "#{record.first_name}"  
         }  
       ],  
       :html=> %Q(<html>Reset your password  <br>

                <a href='#{ opts[:redirect_url] }'>Reset password</a></html>), 
       :from_email=> "alan@learnyourlesson.ie"  
      }
      async = false
      sending = m.messages.send message, async
      puts sending
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end
  end
end

# http://localhost:3000/#/teachers/password/edit?reset_password_token=yay5s7yqAaBj1osHKDD1