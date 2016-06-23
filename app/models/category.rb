# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
	has_many :subjects, dependent: :destroy
	validates :name, presence: true, uniqueness: true
end
