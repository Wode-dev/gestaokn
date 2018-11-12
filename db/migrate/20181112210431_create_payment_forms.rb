class CreatePaymentForms < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_forms do |t|
      t.string :kind
      t.string :place

      t.timestamps
    end
  end
end
