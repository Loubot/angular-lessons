class AddCountyToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :county, :text
  end
end
