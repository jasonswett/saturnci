module API
  module V1
    class SystemLogsController < APIController
      def create
        job = Job.find(params[:job_id])
        request.body.rewind
        log_chunk = request.body.read
        job.update!(system_logs: job.system_logs.to_s + log_chunk)

        Streaming::JobOutputStream.new(
          job: job,
          tab_name: "system_logs"
        ).broadcast

        head :ok
      end
    end
  end
end
