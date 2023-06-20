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
  end
end
