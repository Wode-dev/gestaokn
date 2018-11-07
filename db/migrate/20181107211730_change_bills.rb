class ChangeBills < ActiveRecord::Migration[5.2]
  def change
    change_column :bills, :reference, :date
    rename_column :bills, :reference, :ref_start
    add_column :bills, :ref_end, :date
  end
end
