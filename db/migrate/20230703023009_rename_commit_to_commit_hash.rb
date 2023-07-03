class RenameCommitToCommitHash < ActiveRecord::Migration[7.0]
  def change
    rename_column :builds, :commit, :commit_hash
  end
end
