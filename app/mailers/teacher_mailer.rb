class TeacherMailer < Devise::Mailer
  require 'pp'
  require   'uri'

  def reset_password_instructions(record, token, opts={})
    p record
    p token
    p
    p "blablablabla"
    p URI.encode( opts[:redirect_url] )
    url = "#{ root_url }api/auth/password/edit?config=default&redirect_url=#{ URI.encode( opts[:redirect_url] ) }&reset_password_token=#{ URI.encode( token ) }"
    
    p url
    
    @token = token    
    #devise_mail(record, :reset_password_instructions, opts)
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "Password reset",  
       :from_name=> "Learn Your Lesson",  
       :text=> %Q(<html>Reset your password  <br>
                <p><a href="#{ url }">Change my password</a></p>),
                # <a href='#{ opts[:redirect_url] }'>Reset password</a>), 
       :to=>[  
         {  
           :email=> record.email,
           :name=> "#{record.first_name}"  
         }  
       ],  
       :html=> %Q(<html>Reset your password  <br>

                <p><a href="#{ url }">Change my password</a></p>),
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

  def user_registered( user )
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "New User",  
       :from_name=> 'Admin',
       :from_email => 'do-not-reply@learnyourlesson.ie',
       :text=> %Q(#{user.email} has registered @ #{Time.now}),  
       :to=>[  
          
          {
            email: 'louisangelini@gmail.com',
            name: 'Admin'
          },
          {
            email: 'alan.rowell28@googlemail.com',
            name: 'Admin'
          }
       ],  
       
      }  
      sending = m.messages.send message  
      puts sending
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end
  end

  def feedback( params )
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "Feedback",  
       :from_name=> params[ :name ],
       :from_email => 'do-not-reply@learnyourlesson.ie',
       :text=> "#{ params[ :text ] }, #{ params[:name] }, #{ params[ :email ] }",  
       :to=>[  
          
          {
            email: 'louisangelini@gmail.com',
            name: 'Admin'
          },
          {
            email: 'alan.rowell28@googlemail.com',
            name: 'Admin'
          }
       ],  
       
      }  
      sending = m.messages.send message  
      return sending
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
        return false
    raise
    end
  end

end


