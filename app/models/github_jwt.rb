require "jwt"

class GitHubJWT
  def self.generate
    private_pem = AWSSecret.read(ENV["GITHUB_PRIVATE_KEY_NAME"])
    private_key = OpenSSL::PKey::RSA.new(private_pem)

    payload = {
      iat: Time.now.to_i, # Issued-at time
      exp: Time.now.to_i + (10 * 60), # JWT expiration time
      iss: ENV["GITHUB_APP_ID"]
    }

    JWT.encode(payload, private_key, "RS256")
  end
end
