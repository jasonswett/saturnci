require "jwt"
require "octokit"

class GitHubToken
  def self.generate(installation_id)
    raise "Installation ID is missing" if installation_id.blank?
    token
  end

  def self.token
    private_pem = AWSSecret.read(ENV["GITHUB_PRIVATE_KEY_NAME"])
    private_key = OpenSSL::PKey::RSA.new(private_pem)

    payload = {
      iat: Time.now.to_i, # Issued-at time
      exp: Time.now.to_i + (10 * 60), # JWT expiration time
      iss: ENV["GITHUB_APP_ID"]
    }

    jwt = JWT.encode(payload, private_key, "RS256")
    client = Octokit::Client.new(bearer_token: jwt)
    installation_token = client.create_app_installation_access_token(installation_id)
    installation_token[:token]
  end
end
