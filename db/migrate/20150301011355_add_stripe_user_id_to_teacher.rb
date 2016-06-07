class AddStripeUserIdToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, 	:stripe_user_id, 	:string
    add_column :teachers,   :address,         :string, default: ''
    add_column :user_carts, :multiple, 				:boolean, default: false
    add_column :user_carts, :weeks, 					:integer, default: 0
    add_column :user_carts, :address,         :string, default: ''
    add_column :user_carts, :home_booking, 		:boolean, defailt: false
    add_column :prices, 		:no_map, 					:boolean, default: false
  end
end
