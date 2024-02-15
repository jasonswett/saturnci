module API
  module V1
    class JobMachineImagesController < APIController
      def update
        JobMachineImage.new(params[:id]).create_snapshot
        head :ok
      end
    end
  end
end
