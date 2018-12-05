class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.string :name
      t.text :address
      t.string :city
      t.string :state
      t.string :neighborhood
      t.string :phone
      t.text :notes

      t.timestamps
    end
  end
end
