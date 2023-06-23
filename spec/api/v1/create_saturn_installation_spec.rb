require "rails_helper"

RSpec.describe API::V1::GitHubEventsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:user) { create(:user, uid: "123456", provider: "github") }

  let(:payload) do
    {
      "action" => "installation",
      "installation" => {
        "id" => "12345",
        "account" => {
          "id" => "123456",
        }
      }
    }
  end

  before do
    request.env["HTTP_X_GITHUB_EVENT"] = "installation"
  end

  it "creates a new saturn installation for the user" do
    expect {
      post :create, params: payload, as: :json
    }.to change { user.saturn_installations.count }.by(1)

    saturn_installation = user.saturn_installations.last
    expect(saturn_installation.github_installation_id).to eq(payload["installation"]["id"])
  end
end
