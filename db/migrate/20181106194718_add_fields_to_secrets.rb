class AddFieldsToSecrets < ActiveRecord::Migration[5.2]
  def change
    add_column :secrets, :enabled?, :boolean
    add_column :secrets, :service, :string
    add_column :secrets, :remote_address, :string
    add_column :secrets, :local_address, :string
  end
end
