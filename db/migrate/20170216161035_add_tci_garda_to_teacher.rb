class AddTciGardaToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :tci, :boolean
    add_column :teachers, :garda, :boolean
  end
end
