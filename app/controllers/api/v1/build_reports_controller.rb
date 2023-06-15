module API
  module V1
    class BuildReportsController < APIController
      def create
        build = Build.find(params[:build_id])
        build.update!(report: params[:build_report][:_json])
      end
    end
  end
end
