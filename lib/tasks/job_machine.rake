# lib/tasks/digitalocean.rake

require 'droplet_kit'

namespace :job_machine do
  desc "Create a Droplet, install Docker, and take a snapshot"
  task :create_image do
    client = DropletKit::Client.new(access_token: ENV['DIGITALOCEAN_ACCESS_TOKEN'])

    cloud_init_script = <<-EOS
#cloud-config

write_files:
- path: /root/setup-docker.sh
  permissions: '0755'
  content: |
    #!/bin/bash
    apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    DROPLET_ID=$(curl -s http://169.254.169.254/metadata/v1/id)

    curl -f -u #{ENV["SATURNCI_API_USERNAME"]}:#{ENV["SATURNCI_API_PASSWORD"]} -X PUT \
        #{ENV["SATURNCI_HOST"]}/api/v1/job_machine_images/$DROPLET_ID

runcmd:
- /root/setup-docker.sh
EOS

    droplet = DropletKit::Droplet.new(
      name: 'docker-droplet',
      region: 'nyc1',
      size: 's-4vcpu-8gb',
      image: 'ubuntu-20-04-x64',
      user_data: cloud_init_script
    )

    created_droplet = client.droplets.create(droplet)

    puts "Droplet #{created_droplet.id} created. Waiting for setup..."

    loop do
      sleep(5)
      droplet_info = client.droplets.find(id: created_droplet.id)
      puts droplet_info.status
    end
  end
end
