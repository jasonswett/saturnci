class AddBranchNameToBuild < ActiveRecord::Migration[7.0]
  def change
    add_column :builds, :branch_name, :string
  end
end
