class AddUniqueIndexToJobsOrderIndex < ActiveRecord::Migration[7.1]
  def change
    add_index :jobs, %i[build_id order_index], unique: true
  end
end
