module API
  module V1
    class JobsController < APIController
      def index
        render json: Job.order("created_at desc")
          .running
          .as_json(methods: :status)
      end
    end
  end
end
