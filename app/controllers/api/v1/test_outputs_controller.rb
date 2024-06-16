module API
  module V1
    class TestOutputsController < APIController
      def create
        job = Job.find(params[:job_id])
        request.body.rewind
        log_chunk = request.body.read
        job.update!(test_output: job.test_output.to_s + log_chunk)

        Turbo::StreamsChannel.broadcast_update_to(
          "job_#{job.id}_test_output",
          target: "build_details_content_test_output",
          partial: "jobs/test_output",
          locals: { job: job, current_tab_name: "test_output" }
        )

        head :ok
      end
    end
  end
end
