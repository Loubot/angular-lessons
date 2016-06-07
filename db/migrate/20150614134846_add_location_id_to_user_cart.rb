class AddLocationIdToUserCart < ActiveRecord::Migration
  def up
    add_column :user_carts, :location_id, :integer
    add_column :teachers, :profile_views, :integer, default: 0
    add_index :user_carts, :student_email
    add_index :user_carts, :student_id
    change_column :events, :student_id, :integer, default: 0
    change_column :events, :teacher_id, :integer, default: 0
  end

  def down
    remove_column :user_carts, :location_id, :integer
    remove_column :teachers, :profile_views, :integer
    remove_index :user_carts, :student_email
    remove_index :user_carts, :student_id
    change_column :events, :student_id, :integer, default: nil
    change_column :events, :teacher_id, :integer, default: nil
  end
  
end
