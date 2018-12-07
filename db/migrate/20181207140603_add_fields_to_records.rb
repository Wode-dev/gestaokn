class AddFieldsToRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :date, :date
    add_column :records, :shift, :integer, limit: 3
  end
end
