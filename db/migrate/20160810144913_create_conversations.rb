class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :teacher_email
      t.string :student_email
      t.string :teacher_name
      t.string :student_name
      t.text :random

      t.timestamps null: false
    end
  end
end
