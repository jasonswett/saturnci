require "rails_helper"

RSpec.describe "GitHub tokens", type: :request do
  describe "POST /api/v1/github_tokens" do
    it "returns a token" do
      user = ENV["SATURNCI_API_USERNAME"]
      password = ENV["SATURNCI_API_PASSWORD"]
      encoded_credentials = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)

      allow(GitHubToken).to receive(:generate).and_return("ABC123")

      post api_v1_github_tokens_path, headers: { "Authorization" => encoded_credentials }
      expect(response.body).to eq("ABC123")
    end
  end
end
