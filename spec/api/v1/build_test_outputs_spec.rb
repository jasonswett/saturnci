require "rails_helper"
include APIAuthenticationHelper

RSpec.describe "build test outputs", type: :request do
  describe "POST /api/v1/builds/:id/test_outputs" do
    let!(:build) { create(:build) }

    it "adds test output to a build" do
      post(
        api_v1_build_test_outputs_path(build_id: build.id),
        params: { test_output: "everything worked" },
        headers: api_authorization_headers
      )

      expect(build.reload.test_output).to eq("everything worked")
    end
  end
end
