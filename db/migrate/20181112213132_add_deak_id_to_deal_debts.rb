class AddDeakIdToDealDebts < ActiveRecord::Migration[5.2]
  def change
    add_column :deal_debts, :deal_id, :integer
  end
end
