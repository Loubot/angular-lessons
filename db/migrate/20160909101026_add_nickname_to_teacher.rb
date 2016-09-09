class AddNicknameToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :nickname, :string
  end
end
