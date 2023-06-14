require "rails_helper"

RSpec.describe "build reports", type: :request do
  describe "POST /api/v1/builds/:id/build_reports" do
    let!(:build) { create(:build) }

    it "adds a report to a build" do
      post api_v1_build_build_reports_path(build_id: build.id),
        params: [].to_json, headers: { "CONTENT_TYPE" => "application/json" }

      expect(build.reload.report).to eq([])
    end
  end
end
