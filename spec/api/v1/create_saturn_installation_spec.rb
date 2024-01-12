require "rails_helper"

RSpec.describe API::V1::GitHubEventsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:user) { create(:user, uid: "55555", provider: "github") }

  context "personal account" do
    let!(:payload) do
      {
        "action" => "created",
        "installation" => {
          "id" => "12345",
          "account" => {
            "id" => "55555",
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

  context "organization" do
    let!(:payload) do
      {"action"=>"created",                                                                                                                         
       "installation"=>                                                                                                                                
      {"id"=>46029919,                                                                                                                               
       "account"=>                                                                                                                                   
      {"login"=>"ben-franklin-labs",
       "id"=>6170947,       
       "node_id"=>"MDEyOk9yZ2FuaXphdGlvbjYxNzA5NDc=",
       "avatar_url"=>"https://avatars.githubusercontent.com/u/6170947?v=4",                 
       "gravatar_id"=>"",                                                                                                                          
       "url"=>"https://api.github.com/users/ben-franklin-labs",                                                                                    
       "html_url"=>"https://github.com/ben-franklin-labs",
       "followers_url"=>"https://api.github.com/users/ben-franklin-labs/followers",
       "following_url"=>"https://api.github.com/users/ben-franklin-labs/following{/other_user}",
       "gists_url"=>"https://api.github.com/users/ben-franklin-labs/gists{/gist_id}",
       "starred_url"=>"https://api.github.com/users/ben-franklin-labs/starred{/owner}{/repo}",
       "subscriptions_url"=>"https://api.github.com/users/ben-franklin-labs/subscriptions",
       "organizations_url"=>"https://api.github.com/users/ben-franklin-labs/orgs",
       "repos_url"=>"https://api.github.com/users/ben-franklin-labs/repos",
       "events_url"=>"https://api.github.com/users/ben-franklin-labs/events{/privacy}",
       "received_events_url"=>"https://api.github.com/users/ben-franklin-labs/received_events",
       "type"=>"Organization",                                            
       "site_admin"=>false},                                              
       "repository_selection"=>"all",                                       
       "access_tokens_url"=>"https://api.github.com/app/installations/46029919/access_tokens",
       "repositories_url"=>"https://api.github.com/installation/repositories",
       "html_url"=>"https://github.com/organizations/ben-franklin-labs/settings/installations/46029919",
       "app_id"=>350839,
       "app_slug"=>"saturnci-development",
       "target_id"=>6170947,
       "target_type"=>"Organization",
       "permissions"=>
      {"contents"=>"read",
       "metadata"=>"read",
       "pull_requests"=>"read",
       "repository_hooks"=>"read",
       "repository_projects"=>"read",
       "organization_projects"=>"read"},
       "events"=>["pull_request", "push"],
       "created_at"=>"2024-01-11T19:33:53.000-05:00",
       "updated_at"=>"2024-01-11T19:33:53.000-05:00",
       "single_file_name"=>nil,
       "has_multiple_single_files"=>false,
       "single_file_paths"=>[],
       "suspended_by"=>nil,
       "suspended_at"=>nil},
       "repositories"=>
      [{"id"=>179154403,
        "node_id"=>"MDEwOlJlcG9zaXRvcnkxNzkxNTQ0MDM=",
        "name"=>"ben-franklin-labs.github.io",
        "full_name"=>"ben-franklin-labs/ben-franklin-labs.github.io",
        "private"=>false},
        {"id"=>565187405,
         "node_id"=>"R_kgDOIbATTQ",
         "name"=>"instant_rails_pro",
         "full_name"=>"ben-franklin-labs/instant_rails_pro",
         "private"=>false}],
         "requester"=>nil,
         "sender"=>
      {"login"=>"jasonswett",
       "id"=>55555,
       "node_id"=>"MDQ6VXNlcjY4MDgxMw==",
       "avatar_url"=>"https://avatars.githubusercontent.com/u/680813?v=4",
       "gravatar_id"=>"",
       "url"=>"https://api.github.com/users/jasonswett",
       "html_url"=>"https://github.com/jasonswett",
       "followers_url"=>"https://api.github.com/users/jasonswett/followers",
       "following_url"=>"https://api.github.com/users/jasonswett/following{/other_user}",
       "gists_url"=>"https://api.github.com/users/jasonswett/gists{/gist_id}",
       "starred_url"=>"https://api.github.com/users/jasonswett/starred{/owner}{/repo}",
       "subscriptions_url"=>"https://api.github.com/users/jasonswett/subscriptions",
       "organizations_url"=>"https://api.github.com/users/jasonswett/orgs",
       "repos_url"=>"https://api.github.com/users/jasonswett/repos",
       "events_url"=>"https://api.github.com/users/jasonswett/events{/privacy}",
       "received_events_url"=>"https://api.github.com/users/jasonswett/received_events",
       "type"=>"User",
       "site_admin"=>false}}
    end

    before do
      request.env["HTTP_X_GITHUB_EVENT"] = "installation"
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
