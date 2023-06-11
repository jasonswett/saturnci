require "jwt"
require "octokit"

class GitHubToken
  APP_ID = 345077
  INSTALLATION_ID = 38411118

  def self.generate
    private_pem = AWSSecret.read("github-private-key")
    private_key = OpenSSL::PKey::RSA.new(private_pem)

    payload = {
      iat: Time.now.to_i, # Issued-at time
      exp: Time.now.to_i + (10 * 60), # JWT expiration time
      iss: APP_ID
    }

    jwt = JWT.encode(payload, private_key, "RS256")
    client = Octokit::Client.new(bearer_token: jwt)
    installation_token = client.create_app_installation_access_token(INSTALLATION_ID)
    installation_token[:token]
  end
end
