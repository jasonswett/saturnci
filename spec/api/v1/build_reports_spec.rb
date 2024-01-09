require "rails_helper"
include APIAuthenticationHelper

RSpec.describe "build reports", type: :request do
  describe "POST /api/v1/builds/:id/build_reports" do
    let!(:build) { create(:build) }

    it "adds a report to a build" do
      post(
        api_v1_build_build_reports_path(build_id: build.id),
        params: "build report content",
        headers: api_authorization_headers.merge({ "CONTENT_TYPE" => "text/plain" })
      )

      expect(build.reload.report).to eq("build report content")
    end
  end
end
