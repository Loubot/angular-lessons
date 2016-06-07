class AddRateToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :rate, :decimal, :precision => 8, :scale => 2
  end
end
