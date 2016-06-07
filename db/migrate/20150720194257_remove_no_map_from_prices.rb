class RemoveNoMapFromPrices < ActiveRecord::Migration
  def change
    remove_column :prices, :no_map, :boolean
  end
end
