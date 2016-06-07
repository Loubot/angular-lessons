class AddCardDetailsToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :paypal_email, :string, default: ""
    add_column :teachers, :stripe_access_token, :string, default: ""
  end
end
