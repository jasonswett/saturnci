module API
  module V1
    class JobEventsController < APIController
      def create
        job = Job.find(params[:job_id])
        job.job_events.create!(type: params[:type])
        head :ok
      end
    end
  end
end
