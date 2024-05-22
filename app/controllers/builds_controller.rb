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

    redirect_to job_detail_content_project_build_job_path(
      @build.project,
      @build,
      @build.jobs.first,
      DEFAULT_PARTIAL
    )
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
