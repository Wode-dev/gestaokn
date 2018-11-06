class ChangeEnabledColumnFromSecrets < ActiveRecord::Migration[5.2]
  def up
    rename_column :secrets, :enabled?, :enabled
  end
  def down
    rename_column :secrets, :enabled, :enabled?
  end
end
