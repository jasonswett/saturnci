module API
  module V1
    class JobsController < APIController
      def index
        render json: Job.all.as_json(methods: :status)
      end
    end
  end
end
