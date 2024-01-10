module API
  module V1
    class BuildMachinesController < APIController
      def destroy
        build = Build.find(params[:build_id])
        build.delete_build_machine
        head :ok
      end
    end
  end
end
