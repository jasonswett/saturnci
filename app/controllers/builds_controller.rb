class BuildsController < ApplicationController
  DEFAULT_PARTIAL = "test_output"

  def create
    @project = Project.find(params[:project_id])
    build = Build.new(project: @project)
    build.start!

    redirect_to build
  end

  def show
    @build = Build.find(params[:id])
    @project = @build.project
    @build_list = BuildList.new(@build, branch_name: params[:branch_name])
    @current_tab_name = params[:partial] || DEFAULT_PARTIAL
  end

  def destroy
    build = Build.find(params[:id])

    begin
      build.delete_job_machines
    rescue DropletKit::Error => e
      if e.message.include?("404")
        Rails.logger.error "Failed to delete job machine: #{e.message}"
      else
        raise
      end
    end

    build.destroy!
    redirect_to project_path(build.project)
  end
end
