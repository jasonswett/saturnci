require "rails_helper"
include APIAuthenticationHelper

RSpec.describe "build logs", type: :request do
  describe "POST /api/v1/builds/:id/build_logs" do
    let!(:build) { create(:build) }

    it "increases the count of build logs by 1" do
      expect {
        post(
          api_v1_build_build_logs_path(build),
          params: "log file content",
          headers: api_authorization_headers.merge({ "CONTENT_TYPE" => "text/plain" })
        )
      }.to change(BuildLog, :count).by(1)
    end

    it "returns an empty 200 response" do
      post(
        api_v1_build_build_logs_path(build),
        params: "log file content",
        headers: api_authorization_headers.merge({ "CONTENT_TYPE" => "text/plain" })
      )
      expect(response).to have_http_status(200)
      expect(response.body).to be_empty
    end
  end
end
