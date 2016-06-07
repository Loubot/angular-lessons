class AddProfileToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :profile, :integer
  end
end
