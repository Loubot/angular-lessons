class AddTimeOffToEvents < ActiveRecord::Migration
  def change
    add_column :events, :time_off, :binary
  end
end
