require_relative '../../../lib/saturnci/client'

describe "authentication" do
  context "invalid credentials" do
    it "outputs a graceful error message" do
      stub_request(:get, "http://localhost:3000/api/v1/builds").to_return(status: 422)

      expect {
        SaturnCI::Client.new(
          username: "",
          password: ""
        )
      }.to raise_error("Bad credentials.")
    end
  end
end
