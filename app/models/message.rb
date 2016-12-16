# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  text            :text
#

class Message < ActiveRecord::Base
  validates :text, :conversation_id, presence: true
  belongs_to :conversation

  
end
