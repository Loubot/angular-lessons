class AddLocationNameToGrinds < ActiveRecord::Migration
  def change
    add_column :grinds, :location_name, :string
  end
end
