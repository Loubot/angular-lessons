class TeacherMailer < Devise::Mailer
  require 'pp'
  def reset_password_instructions(record, token, opts={})
    pp record.reset_password_token
    puts "record: #{record} token: #{token} opts: #{opts}  #{:reset_password_instructions}"
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
                <a href="http://localhost:3000?client_id=5qzNUaA__3Qlx9zrMEIygA&config=default&expiry=&reset_password=true&token=#{ record.reset_password_token }&uid=#{opts[:email]}">Reset Password</a>),
                # <a href='#{ opts[:redirect_url] }'>Reset password</a>), 
       :to=>[  
         {  
           :email=> record.email,
           :name=> "#{record.first_name}"  
         }  
       ],  
       :html=> %Q(<html>Reset your password  <br>

                <a href="http://localhost:3000/#/reset-password/5qzNUaA__3Qlx9zrMEIygA/default/expiry/true/#{ record.reset_password_token }/#{opts[:email]}/#{ opts[:redirect_url]}">Reset Password</a>),
                # <a href="#{ opts[:red#/irect_url] }?client_id=5qzNUaA__3Qlx9zrMEIygA&config=default&expiry=&reset_password=true&token=#{ record.reset_password_token }&uid=#{opts[:email]}">Reset Password</a>),
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
# http://localhost:3000/?client_id=5qzNUaA__3Qlx9zrMEIygA&config=default&expiry=&reset_password=true&token=v_Uy3f9OM_C4ykSGpigomA&uid=lllouis%40yahoo.com#/view-teacher/10
# http://localhost:3000/#/reset-password?client_id=5qzNUaA__3Qlx9zrMEIygA&config=default&expiry=&reset_password=true&token=v_Uy3f9OM_C4ykSGpigomA&uid=lllouis@yahoo.com#%2F