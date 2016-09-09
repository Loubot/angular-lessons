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
  
  has_many :qualifications, dependent: :destroy
  include DeviseTokenAuth::Concerns::User

  validates :email,  uniqueness: { case_sensitive: false }
  validates :email, :first_name, :last_name, presence: true
  validates_confirmation_of :password, message: "should match verification"

end
