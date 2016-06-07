class CreateQualifications < ActiveRecord::Migration
  def change
    create_table :qualifications do |t|
      t.string :title
      t.string :school
      t.datetime :start
      t.datetime :end
      t.integer :teacher_id
      t.timestamps
    end
  end
end
