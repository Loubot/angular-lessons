class Teacher < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  has_many :photos, as: :imageable, dependent: :destroy

  has_and_belongs_to_many :subjects, touch: true
  include DeviseTokenAuth::Concerns::User
end
