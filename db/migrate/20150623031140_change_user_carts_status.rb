class ChangeUserCartsStatus < ActiveRecord::Migration
  def change
    add_column :user_carts, :status, :string, default: ''
  end
end
