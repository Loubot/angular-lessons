class AddUserId1NotificationUserId2NotificationToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :user_id1_notification, :integer, default: 0
    add_column :conversations, :user_id2_notification, :integer, default: 0
  end
end
