require "jwt"

class GitHubToken
  INSTALLATION_ID = 38411118

  def self.generate
    OctokitClient.create
    client = Octokit::Client.new(bearer_token: jwt)
    installation_token = client.create_app_installation_access_token(INSTALLATION_ID)
    installation_token[:token]
  end
end
