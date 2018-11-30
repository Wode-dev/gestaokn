class CreateSyncs < ActiveRecord::Migration[5.2]
  def change
    create_table :syncs do |t|
      t.string :table
      t.string :column
      t.text :value
      t.text :mk_value

      t.timestamps
    end
  end
end
