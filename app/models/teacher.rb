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
#  email                  :string
#  first_name             :string
#  last_name              :string
#  calendar_id            :string
#  overview               :text
#  is_teacher             :boolean          default(FALSE)
#  tokens                 :text
#  created_at             :datetime
#  updated_at             :datetime
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
  include DeviseTokenAuth::Concerns::User

  validates :email,  uniqueness: { case_sensitive: false }
  validates :email, :first_name, :last_name, presence: true
  validates_confirmation_of :password, message: "should match verification"


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

end
