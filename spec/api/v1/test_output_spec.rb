require "rails_helper"
include APIAuthenticationHelper

RSpec.describe "test output", type: :request do
  describe "POST /api/v1/builds/:id/test_output" do
    let!(:build) { create(:build) }

    it "adds test output to a build" do
      post(
        api_v1_build_test_output_path(build_id: build.id),
        params: "test output content",
        headers: api_authorization_headers.merge({ "CONTENT_TYPE" => "text/plain" })
      )

      expect(build.reload.test_output).to eq("test output content")
    end
  end
end
