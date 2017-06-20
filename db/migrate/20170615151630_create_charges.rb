class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.integer :teacher_id
      t.integer :mins
      # t.decimal :price, precision: 8, scale: 2
      t.integer :price, default: 0

      t.timestamps null: false
    end

    add_index :charges, :teacher_id
  end
end
