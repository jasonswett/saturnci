class DropOldTables < ActiveRecord::Migration[7.1]
  def change
    drop_table :build_events
    drop_table :build_logs
  end
end
