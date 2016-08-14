class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :message
      t.string :sender_email
      t.integer :conversation_id

      t.timestamps null: false
    end
  end
end
