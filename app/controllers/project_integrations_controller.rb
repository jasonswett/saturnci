require "jwt"
require "octokit"

class ProjectIntegrationsController < ApplicationController
  def new
    client = Octokit::Client.new(
      access_token: session[:github_oauth_token]
    )
    client.auto_paginate = true

    @repositories = client.repositories
  end

  def create
    client = Octokit::Client.new(
      access_token: session[:github_oauth_token]
    )

    repo_full_name = params[:repo_full_name]
    repo = client.repo(repo_full_name)

    project = Project.create!(
      name: repo_full_name,
      github_repo_full_name: repo_full_name
    )

    redirect_to project
  end
end
