class BuildsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    build = Build.new(project: @project)
    build.start!

    redirect_to @project
  end

  def show
    @build = Build.find(params[:id])
  end
end
