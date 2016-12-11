# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  message         :text
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Message < ActiveRecord::Base
  validates :message, :conversation_id, :sender_email, presence: true
  belongs_to :conversation

  
end
