class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
