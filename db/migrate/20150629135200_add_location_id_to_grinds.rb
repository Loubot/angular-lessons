class AddLocationIdToGrinds < ActiveRecord::Migration
  def change
    add_column :grinds, :location_id, :integer
    change_column :grinds, :number_booked, :integer, default: 0
  end
end
