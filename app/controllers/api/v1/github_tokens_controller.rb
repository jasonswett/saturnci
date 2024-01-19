module API
  module V1
    class GitHubTokensController < APIController
      def create
        Rails.logger.info "Raw request body: #{request.raw_post}"
        Rails.logger.info "GitHub token params: #{params.inspect}"

        render plain: GitHubToken.generate(params[:github_installation_id])
      rescue GitHubToken::MissingGitHubPrivateKeyError
        render plain: "Missing GitHub private key", status: 500
      end
    end
  end
end
