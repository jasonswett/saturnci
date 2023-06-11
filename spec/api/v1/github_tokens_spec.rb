require "rails_helper"

RSpec.describe "GitHub tokens", type: :request do
  describe "POST /api/v1/github_tokens" do
    it "returns a token" do
      allow(GitHubToken).to receive(:generate).and_return("ABC123")
      post api_v1_github_tokens_path

      expect(JSON.parse(response.body)).to eq({
        "token" => "ABC123"
      })
    end
  end
end
