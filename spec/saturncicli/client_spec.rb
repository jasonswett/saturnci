require_relative "../../lib/saturncicli/client"
require_relative "helpers/authentication_helper"
require_relative "helpers/api_helper"

describe "client" do
  describe "jobs" do
    before do
      AuthenticationHelper.stub_authentication_request

      body = [
        {
          "build_id" => "3cbe1b26",
          "created_at" => "2024-02-28 15:38:06"
        }
      ].to_json

      APIHelper.stub_body("api/v1/jobs", body)
    end

    let!(:client) do
      SaturnCICLI::Client.new(
        username: ENV["SATURNCI_API_USERNAME"],
        password: ENV["SATURNCI_API_PASSWORD"]
      )
    end

    it "shows jobs" do
      expected_output = <<~OUTPUT
      Build ID  Created
      3cbe1b26  2024-02-28 15:38:06
      56d2a863  2024-02-28 15:36:18
      7c8dd048  2024-02-28 01:57:05
      65a7e250  2024-02-28 01:52:07
      OUTPUT

      expect {
        client.execute("jobs")
      }.to output(expected_output).to_stdout
    end
  end
end
