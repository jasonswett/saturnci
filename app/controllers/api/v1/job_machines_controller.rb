module API
  module V1
    class JobMachinesController < APIController
      def destroy
        job = Job.find(params[:job_id])
        job.delete_job_machine
        head :ok
      end
    end
  end
end
