class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :teacher_id
      t.float :latitude
      t.float :longitude
      t.string :name
      t.text :address

      t.timestamps
    end
    add_index :locations, :teacher_id
    add_column :prices, :location_id, :integer
    add_column :prices, :price, :decimal, :precision => 8, :scale => 2

    remove_column :prices, :travel_price, :decimal, :precision => 8, :scale => 2, default: 0.0, null: false
    remove_column :prices, :home_price, :decimal, :precision => 8, :scale => 2, default: 0.0, null: false
    remove_column :teachers, :lat, :float
  end
end
