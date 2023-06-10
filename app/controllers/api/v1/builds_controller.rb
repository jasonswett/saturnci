class API::V1::BuildsController < ApplicationController
  def create
    project = Project.first
    project.builds.create!
  end
end
