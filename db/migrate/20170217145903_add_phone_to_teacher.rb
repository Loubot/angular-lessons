class AddPhoneToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :phone, :string, default: ""
  end
end
