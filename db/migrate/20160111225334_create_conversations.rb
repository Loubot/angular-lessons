class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :teacher_id
      t.integer :student_id
      t.string :teacher_email
      t.string :student_email
      t.string :teacher_name
      t.string :student_name

      t.timestamps null: false
    end
    add_index :conversations, :teacher_id
    add_index :conversations, :student_id
    add_index :conversations, :student_email
  end
  

end
