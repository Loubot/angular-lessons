class ChangeExperienceDescriptionToText < ActiveRecord::Migration
  def up
    change_column :experiences, :description, :text
  end

  def down
    change_column :experiences, :description, :string
  end

  def change
    remove_column :experiences, :text, :text
  end
end
