class CreateOpenings < ActiveRecord::Migration
  def change
    create_table :openings do |t|
      t.datetime :mon_open
      t.datetime :mon_close
      t.datetime :tues_open
      t.datetime :tues_close
      t.datetime :wed_open
      t.datetime :wed_close
      t.datetime :thur_open
      t.datetime :thur_close
      t.datetime :fri_open
      t.datetime :fri_close
      t.datetime :sat_open
      t.datetime :sat_close
      t.datetime :sun_open
      t.datetime :sun_close
      t.integer :teacher_id

      t.timestamps
    end
    add_index :openings, :teacher_id, unique: true
  end
end
