class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.integer :secret_id
      t.string :transfer_rate
      t.decimal :value
      t.string :profile_name

      t.timestamps
    end
  end
end
