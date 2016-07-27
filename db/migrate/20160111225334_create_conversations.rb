class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :teacher_email
      t.string :student_email
      t.string :teacher_name
      t.string :student_name

      t.timestamps null: false
    end
    add_index :conversations, :teacher_email
    add_index :conversations, :student_email
  end
  

end
