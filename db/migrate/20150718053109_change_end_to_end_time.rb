class ChangeEndToEndTime < ActiveRecord::Migration
  def change
  	rename_column :qualifications, :end, :end_time
  	rename_column :experiences, :end, :end_time
  end
end
