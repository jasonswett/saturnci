module API
  module V1
    class SystemLogsController < APIController
      def create
        # The system logs aren't showing up.
        # Is the problem that the job isn't sending the logs properly
        # or that this controller isn't saving them properly?
        job = Job.find(params[:job_id])
        request.body.rewind
        log_chunk = request.body.read
        puts "-" * 80
        puts "log chunk:"
        puts log_chunk
        puts "-" * 80

        # Append the new chunk of logs to the existing logs
        job.system_logs = (job.system_logs || "") + log_chunk
        job.save!

        head :ok
      end
    end
  end
end
