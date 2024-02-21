require "rails_helper"
include APIAuthenticationHelper

RSpec.describe "builds", type: :request do
  describe "GET /api/v1/builds" do
    it "works" do
      get(
        api_v1_builds_path,
        headers: api_authorization_headers
      )
      expect(response).to have_http_status(200)
    end
  end
end
