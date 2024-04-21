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

# Install certbot
snap install --classic certbot

# Request certificates (Example using manual DNS challenge for demonstration. Adjust as needed)
# certbot certonly --manual --preferred-challenges=dns -d registrycache.saturnci.com

# Assuming certificates are now available at /etc/letsencrypt/live/yourdomain.com/
# Configure Docker Registry with TLS
mkdir -p /etc/docker/registry
docker run -d -p 443:5000 --restart=always --name registry \
  -v /etc/letsencrypt/live/registrycache.saturnci.com/fullchain.pem:/certs/domain.crt \
  -v /etc/letsencrypt/live/registrycache.saturnci.com/privkey.pem:/certs/domain.key \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  registry:2
    SCRIPT
  end
end
