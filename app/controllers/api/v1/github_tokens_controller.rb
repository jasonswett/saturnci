class API::V1::GitHubTokensController < ApplicationController
  def create
    render json: { token: GitHubToken.generate }
  end
end
