class AddMkIdToSecrets < ActiveRecord::Migration[5.2]
  def change
    add_column :secrets, :mk_id, :string
  end
end
