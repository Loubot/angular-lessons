class AddTravelToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :travel, :boolean, default: false
    add_column :teachers, :tci, :boolean, default: false
    add_column :teachers, :garda, :boolean, default: false
  end
end
