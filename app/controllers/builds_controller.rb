class BuildsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    Build.start!(@project)

    redirect_to @project
  end
end
