class AddLevelsToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :levels, :string
  end
end
