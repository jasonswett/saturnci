require "aws-sdk-secretsmanager"

class AWSSecret
  def self.read(secret_id)
    client = Aws::SecretsManager::Client.new(region: 'us-east-2')
    client.get_secret_value(secret_id: secret_id).secret_string
  end
end
