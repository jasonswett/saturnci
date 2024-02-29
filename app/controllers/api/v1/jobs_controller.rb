module API
  module V1
    class JobsController < APIController
      def index
        render json: Job.running.as_json(methods: :status)
      end
    end
  end
end
