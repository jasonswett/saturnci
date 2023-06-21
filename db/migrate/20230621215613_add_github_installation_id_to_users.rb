class AddGitHubInstallationIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :saturn_github_installation_id, :string
  end
end
