# == Schema Information
#
# Table name: subjects
#
#  id          :integer          not null, primary key
#  name        :string
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Subject < ActiveRecord::Base
	belongs_to :category, touch: true
  has_many :prices, dependent: :destroy
  has_many :packages, dependent: :destroy
  has_many :grinds, dependent: :destroy
  validates :name, :category_id, presence: true
  validates :name, uniqueness: true

	has_and_belongs_to_many :teachers, touch: true
end
