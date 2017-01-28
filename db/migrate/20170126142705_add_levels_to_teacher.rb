class AddLevelsToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :primary, :boolean
    add_column :teachers, :jc, :boolean
    add_column :teachers, :lc, :boolean
    add_column :teachers, :third_level, :boolean


    add_index :teachers, :primary
    add_index :teachers, :jc
    add_index :teachers, :lc
    add_index :teachers, :third_level
  end
end
