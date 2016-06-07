class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :subject_name, default: ''
      t.integer :teacher_id
      t.integer :subject_id
      t.decimal :price,       default: 0
      t.integer :no_of_lessons, default: 0

      t.timestamps null: false
    end
    add_index :packages, :teacher_id
    add_index :packages, :subject_id
  end
end
