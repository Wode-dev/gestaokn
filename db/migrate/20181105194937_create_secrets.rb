class CreateSecrets < ActiveRecord::Migration[5.2]
  def change
    create_table :secrets do |t|
      t.string :name
      t.text :address
      t.string :city
      t.string :state
      t.string :neighborhood
      t.string :doc_name
      t.string :doc_value
      t.string :secret
      t.string :secret_password
      t.string :wireless_ssid
      t.string :wireless_password
      t.string :due_date
      t.integer :plan_id

      t.timestamps
    end
  end
end
