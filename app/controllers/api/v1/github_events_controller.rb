module API
  module V1
    class GitHubEventsController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!

      def create
        payload_raw = request.body.read
        payload = JSON.parse(payload_raw)
        Rails.logger.info "GitHub webhook payload: #{payload.inspect}"

        case payload["action"]
        when "created"
          handle_installation_event(payload)
        else
          handle_push_event(payload)
        end

        head :ok
      end

      private

      def handle_installation_event(payload)
        github_installation_id = payload["installation"]["id"]
        github_account_id = payload["installation"]["account"]["id"]

        user = User.find_by(uid: github_account_id, provider: "github")
        user&.saturn_installations&.create!(github_installation_id: github_installation_id)
      end

      def handle_push_event(payload)
        repo_full_name = params[:repository][:full_name]
        @project = Project.find_by!(github_repo_full_name: repo_full_name)

        ref_path = payload["ref"]
        build = Build.new(project: @project)
        build.branch_name = ref_path.split("/").last
        build.commit = payload["after"]
        build.start!
      end
    end
  end
end
