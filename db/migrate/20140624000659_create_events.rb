class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.timestamp :start_time
      t.timestamp :end_time
      t.string :status

      t.timestamps
    end
  end
end
