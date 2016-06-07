class AddTeacherIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :teacher_id, :integer
  end
end
