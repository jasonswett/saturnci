require "rails_helper"

RSpec.describe "GitHub tokens", type: :request do
  describe "POST /api/v1/github_tokens" do
    it "returns a token" do
      post api_v1_github_tokens_path
    end
  end
end
