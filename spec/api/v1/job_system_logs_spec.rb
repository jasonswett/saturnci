require "rails_helper"
include APIAuthenticationHelper

RSpec.describe "system logs", type: :request do
  describe "POST /api/v1/jobs/:id/system_logs" do
    let!(:job) { create(:job) }

    it "adds system logs to a job" do
      post(
        api_v1_job_system_logs_path(job_id: job.id),
        params: "system log content",
        headers: api_authorization_headers.merge({ "CONTENT_TYPE" => "text/plain" })
      )

      expect(job.reload.system_logs).to eq("system log content")
    end
  end
end
