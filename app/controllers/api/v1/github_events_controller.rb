module API
  module V1
    class GitHubEventsController < APIController
      def create
        payload_raw = request.body.read
        payload = JSON.parse(payload_raw)
        Rails.logger.info "GitHub webhook payload: #{payload.inspect}"

        repo_full_name = params[:repository][:full_name]
        Rails.logger.info "Finding project with full name: #{repo_full_name}"
        @project = Project.find_by!(github_repo_full_name: repo_full_name)

        Rails.logger.info "Creating new build for project: #{@project.id}"
        build = Build.new(project: @project)
        build.start!

        head :ok
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error "Project not found: #{e.message}"
        head :not_found
      rescue => e
        Rails.logger.error "Error creating build: #{e.message}"
        head :internal_server_error
      end
    end
  end
end
