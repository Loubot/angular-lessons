class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :uid
      t.string :provider
      t.references :teacher

      t.timestamps
    end

    add_index :identities, :teacher_id
  end
end
