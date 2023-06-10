class API::V1::BuildsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    project = Project.first
    project.builds.create!
  end
end
