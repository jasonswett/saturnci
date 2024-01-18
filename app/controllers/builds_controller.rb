class BuildsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    build = Build.new(project: @project)
    build.start!

    redirect_to build
  end

  def show
    render_turbo_stream Build.find(params[:id]), "builds/show"
  end

  def system_logs
    render_turbo_stream Build.find(params[:build_id]), "builds/system_logs"
  end

  def test_report
    render_turbo_stream Build.find(params[:build_id]), "builds/test_report"
  end

  def destroy
    build = Build.find(params[:id])

    begin
      build.delete_build_machine
    rescue DropletKit::Error => e
      if e.message.include?("404")
        Rails.logger.error "Failed to delete build machine: #{e.message}"
      else
        raise
      end
    end

    build.destroy!
    redirect_to project_path(build.project)
  end

  private

  def render_turbo_stream(build, partial)
    @build = build
    @build_list = BuildList.new(@build, branch_name: params[:branch_name])

    respond_to do |format|
      format.html

      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "build_details",
          partial: partial,
          locals: { build: @build }
        )
      end
    end
  end
end
