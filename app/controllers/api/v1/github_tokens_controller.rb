class API::V1::GitHubTokensController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    render json: { token: GitHubToken.generate }
  end
end
