# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  message         :text
#  sender_email    :text
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Message < ActiveRecord::Base
  validates :message, :conversation_id, presence: true
  belongs_to :conversation

  
end
