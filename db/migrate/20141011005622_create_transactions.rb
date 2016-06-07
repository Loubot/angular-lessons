class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :sender
      t.string :trans_id
      t.string :payStripe
      t.integer :user_id
      t.integer :teacher_id
      t.datetime :pay_date
      t.string :tracking_id
      t.text :whole_message

      t.timestamps
    end

    add_index :transactions, :tracking_id, unique: true
  end
end
