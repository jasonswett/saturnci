module API
  module V1
    class GitHubEventsController < APIController
      def create
        payload_raw = request.body.read
        payload = JSON.parse(payload_raw)
        Rails.logger.info "GitHub webhook payload: #{payload.inspect}"
        render json: { message: "success" }, status: :ok
      end
    end
  end
end
