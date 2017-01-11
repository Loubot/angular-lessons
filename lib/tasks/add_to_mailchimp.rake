task :add_to_mailchimp => :environment  do
  Teacher.all.each do |t|
    gb = Gibbon::API.new(ENV['_mail_chimp_api'], { :timeout => 15 })
    list_id = t.is_teacher ? ENV['MAILCHIMP_TEACHER_LIST'] : ENV['MAILCHIMP_STUDENT_LIST']
    
    begin
      gb.lists.subscribe({
                          :id => list_id,
                           :email => {
                                      :email => t.email                                       
                                      },
                                      :merge_vars => { :FNAME => t.first_name },
                            :double_optin => false
                          })

      p "subscribed to mailchimp"
      # flash[:success] = "Thank you, your sign-up request was successful! Please check your e-mail inbox."
    rescue Gibbon::MailChimpError, StandardError => e
      puts "list subscription failed !!!!!!!!!!"
      p e.to_s
      # flash[:danger] = e.to_s
    end
  end

end
