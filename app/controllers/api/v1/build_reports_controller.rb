module API
  module V1
    class BuildReportsController < APIController
      def create
        build = Build.find(params[:build_id])
        request.body.rewind
        build.update!(report: request.body.read)

        head :ok
      end
    end
  end
end
