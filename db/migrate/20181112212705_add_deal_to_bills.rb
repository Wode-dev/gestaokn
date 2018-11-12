class AddDealToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :deal, :boolean, default: false
  end
end
