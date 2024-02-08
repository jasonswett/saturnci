module API
  module V1
    class JobMachineImagesController < APIController
      def update
        client = DropletKit::Client.new(access_token: ENV['DIGITALOCEAN_ACCESS_TOKEN'])
        client.droplet_actions.shutdown(droplet_id: params[:id])
        head :ok
      end
    end
  end
end
