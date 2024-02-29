module API
  module V1
    class JobsController < APIController
      def index
        render json: Job.running
          .order("created_at desc")
          .as_json(methods: :status)
      end
    end
  end
end
