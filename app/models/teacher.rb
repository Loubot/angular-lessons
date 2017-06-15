# == Schema Information
#
# Table name: teachers
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  profile                :integer
#  email                  :string
#  first_name             :string
#  last_name              :string
#  overview               :text
#  is_teacher             :boolean          default(FALSE)
#  tokens                 :text
#  created_at             :datetime
#  updated_at             :datetime
#  admin                  :boolean          default(FALSE)
#  view_count             :integer          default(0)
#  primary                :boolean
#  jc                     :boolean
#  lc                     :boolean
#  third_level            :boolean
#  travel                 :boolean          default(FALSE)
#  tci                    :boolean          default(FALSE)
#  garda                  :boolean          default(FALSE)
#  phone                  :string           default("")
#  unread                 :boolean          default(FALSE)
#

class Teacher < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  has_many :photos, as: :imageable, dependent: :destroy

  has_and_belongs_to_many :subjects, -> { uniq }, touch: true

  has_one :experience, dependent: :destroy

  has_one :location, dependent: :destroy

  has_many :identities, dependent: :destroy
  
  has_many :qualifications, dependent: :destroy

  has_many :charges, dependent: :destroy
  include DeviseTokenAuth::Concerns::User

  validates :email,  uniqueness: { case_sensitive: false }
  validates :email, presence: true
  validates :phone, numericality: true, allow_nil: true, allow_blank: true
  validates_confirmation_of :password, message: "should match verification"


  after_create :send_new_message, :add_to_mailchimp

  serialize :levels

  after_save :update_conversations #If user changes name all names in conversations have to be changed too. 


  def get_full_name
    "#{ self.first_name } #{ self.last_name }"
  end


  def add_identity(auth)
    p "add identity"
    pp auth['uid']
    Identity.create!(uid: auth['uid'], provider: auth['provider'], teacher_id: self.id)
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    p "Teacher model"
    pp auth
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.teacher

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth['info']['email'] && (auth['info']['verified'] || auth['info']['verified_email'])
      email = auth['info']['email'] 
      user = Teacher.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = Teacher.new(
          first_name: auth['info']['name'],
          #username: auth.info.nickname || auth.uid,
          email: email,
          password: Devise.friendly_token[0,20]
        )
        # user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.teacher != user
      identity.teacher = user
      identity.save!
    end
    user
  end

  private
    def send_new_message
      
      if Rails.env.production?
        logger.debug "I am sending a new message"
        TeacherMailer.delay.user_registered( self )
      else
        # TeacherMailer.user_registered( self ).deliver_now
      end
    end

    def add_to_mailchimp
      return if !Rails.env.production?
      gb = Gibbon::API.new(ENV['_mail_chimp_api'], { :timeout => 15 })
      list_id = self.is_teacher ? ENV['MAILCHIMP_TEACHER_LIST'] : ENV['MAILCHIMP_STUDENT_LIST']
      
      begin
        gb.lists.subscribe({
                            :id => list_id,
                             :email => {
                                        :email => self.email                                       
                                        },
                                        :merge_vars => { :FNAME => self.first_name },
                              :double_optin => false
                            })

        logger.info "subscribed to mailchimp"
        # flash[:success] = "Thank you, your sign-up request was successful! Please check your e-mail inbox."
      rescue Gibbon::MailChimpError, StandardError => e
        puts "list subscription failed !!!!!!!!!!"
        logger.info e.to_s
        # flash[:danger] = e.to_s
      end
    end

    def update_conversations # Update users conversations to refelct names if names are changed. 
      if first_name_changed? or last_name_changed?
        conversations = Conversation.where( user_id1: self.id )
        conversations.update_all( user_name1: self.get_full_name() )
        conversations = Conversation.where( user_id2: self.id )
        conversations.update_all( user_name2: self.get_full_name() )
      end
    end

end
