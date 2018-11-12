class CreateDealDebts < ActiveRecord::Migration[5.2]
  def change
    create_table :deal_debts do |t|
      t.integer :former
      t.integer :current

      t.timestamps
    end
  end
end
