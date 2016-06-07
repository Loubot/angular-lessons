class AddIsTeacherToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :is_teacher, :boolean, null: false, default: false
  end
end
