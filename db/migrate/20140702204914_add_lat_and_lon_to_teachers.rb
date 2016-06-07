class AddLatAndLonToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :lat, :float
    add_column :teachers, :lon, :float
  end
end
