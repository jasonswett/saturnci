module API
  module V1
    class SystemLogsController < APIController
      def create
        job = Job.find(params[:job_id])
        request.body.rewind
        log_chunk = request.body.read

        # Append the new chunk of logs to the existing logs
        job.system_logs = (job.system_logs || "") + log_chunk
        job.save!

        head :ok
      end
    end
  end
end
