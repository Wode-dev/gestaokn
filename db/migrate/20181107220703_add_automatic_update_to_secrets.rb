class AddAutomaticUpdateToSecrets < ActiveRecord::Migration[5.2]
  def change
    add_column :secrets, :automatic_update, :boolean, default: true
  end
end
