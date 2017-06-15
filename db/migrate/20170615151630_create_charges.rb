class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.integer :teacher_id
      t.integer :mins
      t.decimal :price, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
