class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter_id
      t.string :inviter_name
      t.string :recipient_email
      t.string :token
      t.boolean :accepted
      t.date :accepted_at

      t.timestamps null: false
    end
    add_index :invitations, :inviter_id
    add_index :invitations, :token
  end
end
