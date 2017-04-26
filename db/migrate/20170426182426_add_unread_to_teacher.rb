class AddUnreadToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :unread, :boolean, default: false
  end
end
