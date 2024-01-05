module API
  module V1
    class TestOutputsController < APIController
      def create
        build = Build.find(params[:build_id])
        build.update!(test_output: params[:test_output])
      end
    end
  end
end
