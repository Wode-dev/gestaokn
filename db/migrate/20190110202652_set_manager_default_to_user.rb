class SetManagerDefaultToUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :manager, :boolean, default: false
  end
end
