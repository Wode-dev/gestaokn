class AddSituationToSecrets < ActiveRecord::Migration[5.2]
  def change
    add_column :secrets, :situation, :decimal
  end
end
