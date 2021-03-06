class AddUserId1UserId2ToConversation < ActiveRecord::Migration
  def change
    remove_column :conversations, :teacher_email, :string
    remove_column :conversations, :student_email, :string
    remove_column :conversations, :teacher_name, :string
    remove_column :conversations, :student_name, :string
    remove_column :conversations, :random, :text

    remove_column :messages, :sender_email, :string
    remove_column :messages, :message, :text

    add_column :messages, :text, :text
    add_column :messages, :sender_id, :integer


    add_column :conversations, :user_id1, :integer
    add_column :conversations, :user_id2, :integer
    add_column :conversations, :user_email1, :string
    add_column :conversations, :user_email2, :string
    add_column :conversations, :user_name1, :string
    add_column :conversations, :user_name2, :string
  end
end
