class RemoveSaturnGitHubInstallationIdFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :saturn_github_installation_id
  end
end
