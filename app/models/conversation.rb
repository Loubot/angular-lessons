# == Schema Information
#
# Table name: conversations
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id1    :integer
#  user_id2    :integer
#  user_email1 :string
#  user_email2 :string
#  user_name1  :string
#  user_name2  :string
#

class Conversation < ActiveRecord::Base

  has_many :messages, dependent: :destroy

  validates :user_id1, :user_id2, :user_email1, :user_email2, :user_name1, :user_name2, presence: true

 
  after_touch :unread_message_update

  def unread_message_update
    require 'pp'
    pp self.messages.last
  end

end
