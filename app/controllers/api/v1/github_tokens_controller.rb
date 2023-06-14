module API
  module V1
    class GitHubTokensController < APIController
      def create
        render plain: GitHubToken.generate
      end
    end
  end
end
