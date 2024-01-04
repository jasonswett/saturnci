module API
  module V1
    class BuildMachinesController < APIController
      def destroy
        build = Build.find(params[:build_id])
        client = DropletKit::Client.new(access_token: ENV['DIGITALOCEAN_ACCESS_TOKEN'])
        client.droplets.delete(id: build.build_machine_id)
        head :ok
      end
    end
  end
end
