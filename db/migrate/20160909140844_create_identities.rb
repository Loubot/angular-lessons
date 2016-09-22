class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :teacher, index: true, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps null: false
    end
  end
end
