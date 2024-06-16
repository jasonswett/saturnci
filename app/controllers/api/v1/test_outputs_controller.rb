module API
  module V1
    class TestOutputsController < APIController
      def create
        job = Job.find(params[:job_id])
        request.body.rewind
        log_chunk = request.body.read
        job.update!(test_output: job.test_output.to_s + log_chunk)

        Streaming::JobOutputStream.new(
          job: job,
          tab_name: "test_output"
        ).broadcast

        head :ok
      end
    end
  end
end
