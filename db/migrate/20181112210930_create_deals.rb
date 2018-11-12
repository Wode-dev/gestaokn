class CreateDeals < ActiveRecord::Migration[5.2]
  def change
    create_table :deals do |t|
      t.text :note

      t.timestamps
    end
  end
end
