class CreateQualifications < ActiveRecord::Migration
  def change
    create_table :qualifications do |t|
      t.string :title
      t.string :school
      t.datetime :start
      t.datetime :end_time
      t.integer :teacher_id
      t.binary :present

      t.timestamps null: false
    end
  end
end
