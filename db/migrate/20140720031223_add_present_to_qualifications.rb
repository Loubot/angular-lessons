class AddPresentToQualifications < ActiveRecord::Migration
  def change
    add_column :qualifications, :present, :binary
  end
end
