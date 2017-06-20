# == Schema Information
#
# Table name: charges
#
#  id         :integer          not null, primary key
#  teacher_id :integer
#  mins       :integer
#  price      :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Charge < ActiveRecord::Base

  belongs_to :teacher, touch: true

  validates :teacher_id, presence: true

  validates_numericality_of :mins, only_integer: true
  validates_numericality_of :price, only_integer: true
end
