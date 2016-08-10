class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :description
      t.string :text
      t.integer :teacher_id
      t.datetime :start
      t.datetime :end_time
      t.binary :present

      t.timestamps null: false
    end
  end
end
