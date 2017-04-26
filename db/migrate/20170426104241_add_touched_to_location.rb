class AddTouchedToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :touched, :boolean, default: false
  end
end
