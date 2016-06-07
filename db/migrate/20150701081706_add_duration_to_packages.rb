class AddDurationToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :duration, :integer, default: 0
  end
end
