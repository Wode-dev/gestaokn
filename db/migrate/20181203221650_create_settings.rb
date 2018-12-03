class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.string :mk_ip
      t.string :mk_user
      t.string :mk_password

      t.timestamps
    end
  end
end
