module API
  module V1
    class TestSuiteFinishedEventsController < APIController
      def create
        job = Job.find(params[:job_id])
        job.job_events.create!(type: "test_suite_finished")
        head :ok
      end
    end
  end
end
