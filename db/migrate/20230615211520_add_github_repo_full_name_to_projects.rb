class AddGitHubRepoFullNameToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :github_repo_full_name, :string
  end
end
