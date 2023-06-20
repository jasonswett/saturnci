require "jwt"
require "octokit"

class OctokitClientFactory
  APP_ID = 345077

  def self.create
    private_pem = AWSSecret.read("github-private-key")
    private_key = OpenSSL::PKey::RSA.new(private_pem)

    payload = {
      iat: Time.now.to_i, # Issued-at time
      exp: Time.now.to_i + (10 * 60), # JWT expiration time
      iss: APP_ID
    }

    jwt = JWT.encode(payload, private_key, "RS256")
    Octokit::Client.new(bearer_token: jwt)
  end
end
