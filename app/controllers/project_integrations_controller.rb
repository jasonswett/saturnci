require "jwt"
require "octokit"

class ProjectIntegrationsController < ApplicationController
  def new
    @saturn_installation = SaturnInstallation.find(params[:saturn_installation_id])

    @repositories = []
    page = 0

    begin
      page += 1
      current_page_repositories = @saturn_installation.octokit_client.get("/installation/repositories", page: page)
      @repositories += current_page_repositories.repositories
    end while current_page_repositories.total_count > @repositories.size
  end

  def create
    @saturn_installation = SaturnInstallation.find(params[:saturn_installation_id])

    repo_full_name = params[:repo_full_name]
    repo = @saturn_installation.octokit_client.repo(repo_full_name)

    project = current_user.projects.create!(
      saturn_installation: @saturn_installation,
      name: repo_full_name,
      github_repo_full_name: repo_full_name
    )

    redirect_to project
  end
end
