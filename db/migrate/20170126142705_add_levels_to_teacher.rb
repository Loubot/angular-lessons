class AddLevelsToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :levels, :text
  end
end
