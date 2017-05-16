class AddPhone1Phone2ToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :phone1, :text
    add_column :conversations, :phone2, :text
  end
end
