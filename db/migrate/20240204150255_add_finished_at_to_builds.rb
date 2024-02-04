class AddFinishedAtToBuilds < ActiveRecord::Migration[7.1]
  def change
    add_column :builds, :finished_at, :timestamp
  end
end
