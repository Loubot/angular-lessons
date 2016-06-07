class CreateGrinds < ActiveRecord::Migration
  def change
    create_table :grinds do |t|
      t.integer :subject_id
      t.integer :teacher_id
      t.string  :subject_name
      t.integer :capacity
      t.integer :number_booked
      t.decimal :price, :precision => 8, :scale => 2, default: 0.0, null: false
      t.datetime :start_time

      t.timestamps null: false
    end
    add_index :grinds, :subject_id
    add_index :grinds, :teacher_id
  end
end
