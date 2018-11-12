class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.integer :secret_id
      t.date :date
      t.decimal :value
      t.integer :payment_form_id
      t.text :note

      t.timestamps
    end
  end
end
