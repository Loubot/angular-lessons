class Teacher < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  has_many :photos, as: :imageable, dependent: :destroy
  include DeviseTokenAuth::Concerns::User
end
