class KeyValuePaiAtSettings < ActiveRecord::Migration[5.2]
  def change
    remove_column :settings, :mk_ip
    remove_column :settings, :mk_user
    remove_column :settings, :mk_password

    add_column :settings, :key, :string
    add_column :settings, :value, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
