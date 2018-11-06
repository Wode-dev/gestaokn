class AddInstalationToSecrets < ActiveRecord::Migration[5.2]
  def change
    add_column :secrets, :instalation, :date
  end
end
