class RemoveOpeningClosingFromTeacher < ActiveRecord::Migration
  def change
    remove_column :teachers, :opening, :datetime
    remove_column :teachers, :closing, :datetime
    add_column :openings, :all_day_mon, :boolean, default: false
    add_column :openings, :all_day_tues, :boolean, default: false
    add_column :openings, :all_day_wed, :boolean, default: false
    add_column :openings, :all_day_thur, :boolean, default: false
    add_column :openings, :all_day_fri, :boolean, default: false
    add_column :openings, :all_day_sat, :boolean, default: false
    add_column :openings, :all_day_sun, :boolean, default: false
  end
end
