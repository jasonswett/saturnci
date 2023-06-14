require "rails_helper"

RSpec.describe "builds events", type: :request do
  describe "POST /api/v1/builds/:id/build_events" do
    let!(:build) { create(:build) }

    it "increases the count of build events by 1" do
      expect {
        post api_v1_build_build_events_path(
          type: "spot_instance_ready",
          build_id: build.id
        )
      }.to change(BuildEvent, :count).by(1)
    end
  end
end
