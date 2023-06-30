module API
  module V1
    class BuildLogsController < APIController
      def create
        build = Build.find(params[:build_id])
        request.body.rewind
        build.build_logs.create!(content: request.body.read)

        head :ok
      end
    end
  end
end
