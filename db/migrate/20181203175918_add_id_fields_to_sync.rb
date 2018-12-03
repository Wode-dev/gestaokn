class AddIdFieldsToSync < ActiveRecord::Migration[5.2]
  def change
    add_column :syncs, :table_id, :integer
    add_column :syncs, :mk_id, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
