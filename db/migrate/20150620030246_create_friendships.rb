class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :teacher_id
      t.integer :student_id

      t.timestamps null: false
    end
  end
end
