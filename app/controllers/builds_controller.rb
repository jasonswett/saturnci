class BuildsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    build = Build.new(project: @project)
    build.start!

    redirect_to build
  end

  def show
    @build = Build.find(params[:id])

    respond_to do |format|
      format.html do
        @project = @build.project

        @builds = @project.builds.order("created_at desc")

        if params[:branch_name].present?
          @builds = @builds.where(branch_name: params[:branch_name])
        end

        @branch_names = @project.builds.map(&:branch_name).uniq
      end

      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "build",
          partial: "builds/detail",
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
