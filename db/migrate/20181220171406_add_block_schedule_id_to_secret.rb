class AddBlockScheduleIdToSecret < ActiveRecord::Migration[5.2]
  def change
    add_column :secrets, :block_schedule_id, :string
  end
end
