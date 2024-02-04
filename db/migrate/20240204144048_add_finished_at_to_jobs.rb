class AddFinishedAtToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :finished_at, :timestamp
  end
end
