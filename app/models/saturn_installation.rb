class SaturnInstallation < ApplicationRecord
  belongs_to :user

  def octokit_client
    bearer_token = GitHubToken.generate(github_installation_id)
    Octokit::Client.new(bearer_token: bearer_token)
  end
end
