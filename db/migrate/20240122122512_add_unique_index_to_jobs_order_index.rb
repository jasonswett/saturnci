class AddUniqueIndexToJobsOrderIndex < ActiveRecord::Migration[7.1]
  def change
    add_index :jobs, :order_index, unique: true
  end
end
