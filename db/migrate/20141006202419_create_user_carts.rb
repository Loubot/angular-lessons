class CreateUserCarts < ActiveRecord::Migration
  def change
    create_table :user_carts do |t|
      t.integer :teacher_id
      t.integer :student_id
      t.text :params
      t.text :tracking_id
      t.string :student_name, default: ''
      t.string :student_email
      t.string :teacher_email      
      t.timestamps
    end

    add_index :user_carts, :tracking_id, unique: true
  end
end
