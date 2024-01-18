module API
  module V1
    class TestOutputsController < APIController
      def create
        build = Build.find(params[:build_id])
        request.body.rewind
        build.update!(test_output: request.body.read)

        head :ok
      end
    end
  end
end
