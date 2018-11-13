class AddActiveToSecrets < ActiveRecord::Migration[5.2]
  def change
    add_column :secrets, :active, :boolean, default: true
  end
end
