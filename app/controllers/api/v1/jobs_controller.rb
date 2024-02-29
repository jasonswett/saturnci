module API
  module V1
    class JobsController < APIController
      def index
        render json: Job.joins(:build)
          .running
          .order("builds.created_at desc")
      end
    end
  end
end
