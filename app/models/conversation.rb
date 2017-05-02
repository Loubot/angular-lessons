# == Schema Information
#
# Table name: conversations
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id1              :integer
#  user_id2              :integer
#  user_email1           :string
#  user_email2           :string
#  user_name1            :string
#  user_name2            :string
#  user_id1_notification :integer          default(0)
#  user_id2_notification :integer          default(0)
#

class Conversation < ActiveRecord::Base

  has_many :messages, dependent: :destroy

  validates :user_id1, :user_id2, :user_email1, :user_email2, :user_name1, :user_name2, presence: true

 
  after_touch :unread_message_update

  def unread_message_update
    require 'pp'
    id = self.messages.last.sender_id == self.user_id1 ? self.user_id2 : self.user_id1
    pp "Teachers id #{ id }"
    t = Teacher.find( id )
    t.update_attributes( unread: true )
    t.save!

    if self.user_id1 == messages.last.sender_id
      p "Got as far as here"
      self.update_attributes( user_id2_notification: true )
    else
      self.update_attributes( user_id1_notification: true )
      p "or even here"
    end
  end

end
