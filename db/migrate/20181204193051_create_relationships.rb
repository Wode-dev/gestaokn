class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :secret_id
      t.text :description

      t.timestamps
    end
  end
end
