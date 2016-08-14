class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :name
      t.integer :imageable_id
      t.string :imageable_type
      t.string :avatar

      t.timestamps null: false
    end
  end
end
