class AddOpeningAndClosingToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :opening, :datetime
    add_column :teachers, :closing, :datetime
  end
end
