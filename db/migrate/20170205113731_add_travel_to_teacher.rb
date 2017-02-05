class AddTravelToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :travel, :boolean, default: false
  end
end
