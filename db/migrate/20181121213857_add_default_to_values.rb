class AddDefaultToValues < ActiveRecord::Migration[5.2]
  def change

    change_column_default :payments, :value, 0 
    change_column_default :bills, :value, 0 
    change_column_default :plans, :value, 0
    change_column_default :secrets, :situation, 0 
  end
end
