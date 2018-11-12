class RemovePaymentDateFromBills < ActiveRecord::Migration[5.2]
  def change
    remove_column :bills, :payment_date
  end
end
