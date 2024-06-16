module API
  module V1
    class TestOutputsController < APIController
      TAB_NAME = "test_output"

      def create
        job = Job.find(params[:job_id])
        request.body.rewind
        log_chunk = request.body.read
        job.update!(test_output: job.test_output.to_s + log_chunk)

        job_output_stream = Streaming::JobOutputStream.new(
          job: job,
          tab_name: TAB_NAME
        )

        Turbo::StreamsChannel.broadcast_update_to(
          job_output_stream.name,
          target: "build_details_content_#{TAB_NAME}",
          partial: "jobs/#{TAB_NAME}",
          locals: { job: job, current_tab_name: "#{TAB_NAME}" }
        )

        head :ok
      end
    end
  end
end
