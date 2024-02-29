require "rails_helper"
include APIAuthenticationHelper

RSpec.describe "jobs", type: :request do
  let!(:job) do
    create(:job, created_at: "2020-01-01T01:00:00")
  end

  describe "GET /api/v1/jobs" do
    it "returns a 200 response" do
      get(
        api_v1_jobs_path,
        headers: api_authorization_headers
      )
      expect(response).to have_http_status(200)
    end

    it "returns a list of jobs" do
      get(
        api_v1_jobs_path,
        headers: api_authorization_headers
      )

      response_body = JSON.parse(response.body)
      expect(response_body[0]["created_at"]).to eq("2020-01-01T01:00:00.000Z")
    end
  end
end