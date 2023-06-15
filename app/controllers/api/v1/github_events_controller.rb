module API
  module V1
    class GitHubEventsController < APIController
      def create
        payload_raw = request.body.read
        payload = JSON.parse(payload_raw)
        Rails.logger.info "GitHub webhook payload: #{payload.inspect}"

        repo_full_name = params[:repository][:full_name]
        @project = Project.find_by!(github_repo_full_name: repo_full_name)
        build = Build.new(project: @project)
        build.start!

        head :ok
      end
    end
  end
end
