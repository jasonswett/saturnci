class AddIndexToJobs < ActiveRecord::Migration[7.1]
  def change
    Job.destroy_all
    add_column :jobs, :order_index, :integer, null: false
  end
end
