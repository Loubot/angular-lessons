# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  message         :text
#  sender_email    :text
#  conversation_id :integer
#  random          :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Message < ActiveRecord::Base
  validates :message, :conversation_id, presence: true
  belongs_to :conversation

  before_validation :add_random


  def add_random
    self.random =  Digest::SHA1.hexdigest([Time.now, rand].join)
  end
end
