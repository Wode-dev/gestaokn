class AddMkIdToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :mk_id, :string
  end
end
