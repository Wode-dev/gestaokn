class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.integer :secret_id
      t.decimal :value
      t.string :reference
      t.text :note
      t.date :due_date

      t.timestamps
    end
  end
end
