class RemoveCalendarIdFromTeacher < ActiveRecord::Migration
  def change
    remove_column :teachers, :calendar_id, :string
  end
end
