class AddUserId1NotificationUserId2NotificationToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :user_id1_notification, :boolean, default: false
    add_column :conversations, :user_id2_notification, :boolean, default: false
  end
end
