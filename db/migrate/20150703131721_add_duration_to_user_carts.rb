class AddDurationToUserCarts < ActiveRecord::Migration
  def change
    add_column :user_carts, :duration, :integer, default: 0
  end
end
