class BuildsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    build = Build.new(project: @project)
    build.start!

    redirect_to build
  end

  def show
    @build = Build.find(params[:id])
    @build_list = BuildList.new(@build, branch_name: params[:branch_name])

    respond_to do |format|
      format.html

      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "build",
          partial: "builds/detail",
          locals: { build: @build }
        )
      end
    end
  end

  def system_logs
    @build = Build.find(params[:build_id])
    @build_list = BuildList.new(@build, branch_name: params[:branch_name])

    respond_to do |format|
      format.html

      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "build_details",
          partial: "builds/system_logs",
          locals: { build: @build }
        )
      end
    end
  end

  def test_report
    @build = Build.find(params[:build_id])
    @build_list = BuildList.new(@build, branch_name: params[:branch_name])

    respond_to do |format|
      format.html

      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "build_details",
          partial: "builds/test_report",
          locals: { build: @build }
        )
      end
    end
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
end
