require 'droplet_kit'

class DockerRegistryCacheMachineRequest
  # Use a base image that's optimized for Docker installations
  DOCKER_OPTIMIZED_IMAGE_ID = 'docker-20-04'

  def create!
    client = DropletKitClientFactory.client

    # Assuming DropletKitClientFactory.client is already authenticated
    # and ready to use, similar to the example provided.
    droplet = DropletKit::Droplet.new(
      name: 'docker-registry-cache',
      region: 'nyc1',
      image: DOCKER_OPTIMIZED_IMAGE_ID,
      size: 's-1vcpu-2gb',
      user_data: user_data,
      tags: ['docker-registry-cache']
      # This example doesn't include SSH keys for simplicity,
      # but you should include them in a real scenario for secure access.
    )

    droplet_request = client.droplets.create(droplet)

    if droplet_request.id
      puts "Droplet created with ID: #{droplet_request.id}"
    else
      raise "Droplet creation not successful"
    end
  end

  private

  def user_data
    <<~SCRIPT
      #!/bin/bash
      apt-get update
      apt-get install -y apt-transport-https ca-certificates curl software-properties-common
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
      add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      apt-get update
      apt-get install -y docker-ce docker-ce-cli containerd.io

      # Configure Docker to start on boot
      systemctl enable docker

      # Run Docker Registry as a container
      mkdir -p /etc/docker/registry
      docker run -d -p 5000:5000 --restart=always --name registry -v /etc/docker/registry:/var/lib/registry registry:2

      # Configure the registry as a pull-through cache
      echo "proxy:\n  remoteurl: https://registry-1.docker.io" > /etc/docker/registry/config.yml

      # Restart the registry to apply the configuration
      docker container stop registry
      docker container start registry
    SCRIPT
  end
end
