module API
  module V1
    class SystemLogsController < APIController
      TAB_NAME = "system_logs"

      def create
        job = Job.find(params[:job_id])
        log_chunk = request.body.read
        job.update!(TAB_NAME => job.attributes[TAB_NAME].to_s + log_chunk)

        Streaming::JobOutputStream.new(
          job: job,
          tab_name: TAB_NAME
        ).broadcast

        head :ok
      end
    end
  end
end
