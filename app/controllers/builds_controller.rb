class BuildsController < ApplicationController
  DEFAULT_PARTIAL = "test_output"

  def create
    @project = Project.find(params[:project_id])
    build = Build.new(project: @project)
    build.start!

    redirect_to build
  end

  def show
    render_build_detail_partial(DEFAULT_PARTIAL)
  end

  def system_logs
    render_build_detail_partial("system_logs")
  end

  def test_report
    render_build_detail_partial("test_report")
  end

  def test_output
    render_build_detail_partial("test_output")
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

  private

  def render_build_detail_partial(partial)
    @build = Build.find(params[:id] || params[:build_id])
    @project = @build.project
    @build_list = BuildList.new(@build, branch_name: params[:branch_name])
    @partial = partial
    render "show"
  end
end
