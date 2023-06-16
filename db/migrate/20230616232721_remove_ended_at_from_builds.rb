class RemoveEndedAtFromBuilds < ActiveRecord::Migration[7.0]
  def change
    remove_column :builds, :ended_at
  end
end
