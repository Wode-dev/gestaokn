class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :rate_limit
      t.decimal :value
      t.string :profile_name

      t.timestamps
    end
  end
end
