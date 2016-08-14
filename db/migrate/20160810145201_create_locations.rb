class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :teacher_id
      t.float :latitude
      t.float :longitude
      t.string :name
      t.text :address

      t.timestamps null: false
    end
  end
end
