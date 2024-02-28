module API
  module V1
    class JobsController < APIController
      def index
        render json: Job.all
      end
    end
  end
end
