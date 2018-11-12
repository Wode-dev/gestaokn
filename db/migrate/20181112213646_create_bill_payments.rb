class CreateBillPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_payments do |t|
      t.integer :bill_id
      t.integer :payment_id

      t.timestamps
    end
  end
end
