class AddNotNullToBuildColumns < ActiveRecord::Migration[7.0]
  def change
    change_column_null :builds, :branch_name, false
    change_column_null :builds, :commit_hash, false
    change_column_null :builds, :commit_message, false
    change_column_null :builds, :author_name, false
  end
end
