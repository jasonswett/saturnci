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
          "created_at" => "2024-02-28 15:38:06",
          "status" => "Passed",
          "build_commit_message" => "Did stuff",
        },
        {
          "build_id" => "56d2a863",
          "created_at" => "2024-02-28 15:36:18",
          "status" => "Passed",
          "build_commit_message" => "Did other stuff",
        },
        {
          "build_id" => "7c8dd048",
          "created_at" => "2024-02-28 01:57:05",
          "status" => "Passed",
          "build_commit_message" => "Did yet other stuff",
        },
        {
          "build_id" => "65a7e250",
          "created_at" => "2024-02-28 01:52:07",
          "status" => "Passed",
          "build_commit_message" => "Did similar but different stuff",
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
      Created              Build status  Build ID  Build commit message
      2024-02-28 15:38:06  Passed        3cbe1b26  Did stuff
      2024-02-28 15:36:18  Passed        56d2a863  Did other stuff
      2024-02-28 01:57:05  Passed        7c8dd048  Did yet other stuff
      2024-02-28 01:52:07  Passed        65a7e250  Did similar but different stuff
      OUTPUT

      expect {
        client.execute("jobs")
      }.to output(expected_output).to_stdout
    end
  end
end
