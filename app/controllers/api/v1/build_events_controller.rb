module API
  module V1
    class BuildEventsController < APIController
      def create
        build = Build.find(params[:build_id])
        build.build_events.create!(type: params[:type])
      end
    end
  end
end
