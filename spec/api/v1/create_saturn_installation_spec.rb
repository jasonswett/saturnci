require "rails_helper"

RSpec.describe API::V1::GitHubEventsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:user) { create(:user, uid: "55555", provider: "github") }

  before do
    request.env["HTTP_X_GITHUB_EVENT"] = "installation"
  end

  context "personal account" do
    let!(:payload) do
      {
        "action" => "created",
        "installation" => {
          "id" => "12345",
          "account" => {
            "login"=>"jasonswett",
            "id" => "55555",
          }
        }
      }
    end

    it "creates a new saturn installation for the user" do
      expect {
        post :create, params: payload, as: :json
      }.to change { user.saturn_installations.count }.by(1)

      saturn_installation = user.saturn_installations.last
      expect(saturn_installation.github_installation_id).to eq(payload["installation"]["id"])
    end

    it "sets the name" do
      post :create, params: payload, as: :json

      saturn_installation = user.saturn_installations.last
      expect(saturn_installation.name).to eq("jasonswett")
    end
  end

  context "organization" do
    let!(:payload) do
      {
        "action" => "created",
        "installation" => {
          "id" => 46029919,
          "account" => {
            "id" => 6170947,
            "type" => "Organization",
          },
          "target_type" => "Organization",
        },
        "sender" => {
          "login" => "jasonswett",
          "id" => 55555,
          "type" => "User",
        }
      }
    end

    it "creates a new saturn installation for the user" do
      expect {
        post :create, params: payload, as: :json
      }.to change { user.saturn_installations.count }.by(1)

      saturn_installation = user.saturn_installations.last
      expect(saturn_installation.github_installation_id).to eq(payload["installation"]["id"].to_s)
    end
  end
end
