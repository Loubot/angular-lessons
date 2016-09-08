# == Schema Information
#
# Table name: conversations
#
#  id            :integer          not null, primary key
#  teacher_email :string
#  student_email :string
#  teacher_name  :string
#  student_name  :string
#  random        :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Conversation < ActiveRecord::Base

  has_many :messages, dependent: :destroy

  validates :student_email, :teacher_email, :teacher_name, :student_name, presence: true

  before_validation :add_random


  def add_random
    self.random =  Digest::SHA1.hexdigest( [ Time.now, rand ].join )
  end
end
