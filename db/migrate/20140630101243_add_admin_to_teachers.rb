class AddAdminToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :admin, :boolean
  end
end
