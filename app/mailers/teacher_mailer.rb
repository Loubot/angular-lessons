class TeacherMailer < Devise::Mailer
  require 'pp'
  require   'uri'

  def reset_password_instructions(record, token, opts={})
    p record
    p token
    p
    p "blablablabla"
    p URI.encode( opts[:redirect_url] )
    
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
                <p><a href="#{ root_url }api/auth/password/edit?config=default&redirect_url=#{ URI.encode( opts[:redirect_url] ) }&reset_password_token=#{ token }">Change my password</a></p>),
                # <a href='#{ opts[:redirect_url] }'>Reset password</a>), 
       :to=>[  
         {  
           :email=> record.email,
           :name=> "#{record.first_name}"  
         }  
       ],  
       :html=> %Q(<html>Reset your password  <br>

                <p><a href="#{ root_url }api/auth/password/edit?config=default&redirect_url=#{ URI.encode( opts[:redirect_url] ) }&reset_password_token=#{ token }">Change my password</a></p>),
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


# <p><a href="http://localhost:3000/api/auth/password/edit?config=default&redirect_url=http%3A%2F%2Flocalhost%3A3000%2F%23%2Freset-password%2F&reset_password_token=iBYSdkgPRMSBCfvxtePj">Change my password</a></p>