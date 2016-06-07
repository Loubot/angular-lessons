class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :subject_id
      t.integer :teacher_id
      t.decimal :home_price, :precision => 8, :scale => 2
      t.decimal :travel_price, :precision => 8, :scale => 2

      t.timestamps
    end

    remove_column :teachers, :rate, :decimal, :precision => 8, scale: 2
    add_column :teachers, :is_active, :boolean, default: false, null: false
    add_column :teachers, :will_travel, :boolean, default: false, null: false
    add_column :user_carts, :subject_id, :integer
    add_column :events, :subject_id, :integer
    # change_column :teachers, :overview, :text, default: ""
    add_index :prices, :subject_id
    add_index :prices, :teacher_id
  end
end
