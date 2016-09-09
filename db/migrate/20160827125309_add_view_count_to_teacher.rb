class AddViewCountToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :view_count, :integer, default: 0
    add_column :teachers, :nickname, :string
    add_column :teachers, :image, :text
    add_column :teachers, :name, :string
  end
end
