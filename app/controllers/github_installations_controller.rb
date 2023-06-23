class GithubInstallationsController < ApplicationController
  def create
    client = Octokit::Client.new(access_token: session[:github_oauth_token])
    response = client.post('/user/installations', { app_slug: "your_github_app_slug" }, accept: 'application/vnd.github.machine-man-preview+json')

    if response.status == 201
      installation_id = response.data["id"]
      current_user.update(saturn_github_installation_id: installation_id)
    end

    redirect_to some_path # Change this to where you want to redirect the user
  end
end
