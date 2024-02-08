require "rails_helper"
include APIAuthenticationHelper

RSpec.describe "job machine instances", type: :request do
  describe "PUT /api/v1/job_machine_instances/:id" do
    before do
      stub_request(:post, "https://api.digitalocean.com/v2/droplets/123456/actions")
        .to_return(status: 200, body: "{}", headers: {})      
    end

    it "returns an empty 200 response" do
      put(
        api_v1_job_machine_image_path(id: "123456"),
        headers: api_authorization_headers
      )

      expect(response).to have_http_status(200)
      expect(response.body).to be_empty
    end
  end
end
