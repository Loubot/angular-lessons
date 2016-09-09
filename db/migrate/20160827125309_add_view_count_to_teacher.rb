class AddViewCountToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :view_count, :integer, default: 0
  end
end
