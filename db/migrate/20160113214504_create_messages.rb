class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :message
      t.text :sender_email
      t.integer :conversation_id

      t.timestamps null: false
    end
    add_index :messages, :conversation_id
  end
end
