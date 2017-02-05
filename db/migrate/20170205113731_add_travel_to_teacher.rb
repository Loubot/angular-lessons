class AddTravelToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :travel, :boolean
  end
end
