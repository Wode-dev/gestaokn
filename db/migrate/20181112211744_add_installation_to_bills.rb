class AddInstallationToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :installation, :boolean, default: false
  end
end
