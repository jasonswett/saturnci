module API
  module V1
    class SystemLogsController < APIController
      def create
        job = Job.find(params[:job_id])
        request.body.rewind
        job.update!(system_logs: request.body.read)

        head :ok
      end
    end
  end
end
