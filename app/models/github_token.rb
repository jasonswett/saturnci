require "octokit"

class GitHubToken
  def self.generate(installation_id)
    raise "Installation ID is missing" if installation_id.blank?
    token(installation_id)
  end

  def self.token(installation_id)
    client = Octokit::Client.new(bearer_token: GitHubJWT.generate)
    installation_token = client.create_app_installation_access_token(installation_id)
    installation_token[:token]
  end
end
