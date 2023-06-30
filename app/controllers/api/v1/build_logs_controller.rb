module API
  module V1
    class BuildLogsController < APIController
      def create
        build = Build.find(params[:build_id])
        build.build_logs.create!(content: params[:content])
        head :ok
      end
    end
  end
end
