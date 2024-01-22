module API
  module V1
    class TestOutputsController < APIController
      def create
        job = Job.find(params[:job_id])
        request.body.rewind
        job.update!(test_output: request.body.read)

        head :ok
      end
    end
  end
end
