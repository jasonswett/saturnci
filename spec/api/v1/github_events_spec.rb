require "rails_helper"
include APIAuthenticationHelper

RSpec.describe "GitHub Events", type: :request do
  describe "POST /api/v1/github_events" do
    let(:payload) do
      {
        "ref": "refs/heads/main",
        "repository": {
          "id": 123,
          "name": "test",
          "full_name": "user/test",
        },
        "pusher": {
          "name": "user",
        },
        "head_commit": {
          "id": "abc123",
        },
      }.to_json
    end

    it "returns 200" do
      post(
        "/api/v1/github_events",
        params: payload,
        headers: api_authorization_headers
      )

      expect(response).to have_http_status(:ok)
    end
  end
end
