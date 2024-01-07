class BuildsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    build = Build.new(project: @project)
    build.start!

    redirect_to @project
  end

  def show
    @build = Build.find(params[:id])
    @project = @build.project

    @builds = @project.builds.order("created_at desc")

    if params[:branch_name].present?
      @builds = @builds.where(branch_name: params[:branch_name])
    end

    @branch_names = @project.builds.map(&:branch_name).uniq
  end
end
