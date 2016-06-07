class AddDurationToPrice < ActiveRecord::Migration
  def change
    add_column :prices, :duration, :integer, default: 0
  end
end
