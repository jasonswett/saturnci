require 'droplet_kit'

class SpotInstanceRequest
  def initialize(build:, github_installation_id:)
    @build = build
    @github_installation_id = github_installation_id
  end

  def create!
    client = DropletKit::Client.new(access_token: ENV['DIGITALOCEAN_ACCESS_TOKEN'])

    droplet = DropletKit::Droplet.new(
      name: "#{@build.project.name.gsub("/", "-")}-build-#{@build.id}",
      region: 'nyc1',
      image: 'ubuntu-20-04-x64',
      size: 's-1vcpu-1gb',
      user_data: user_data,
      tags: ['saturnci'],
      ssh_keys: []
    )

    created_droplet = client.droplets.create(droplet)

    begin
      sleep(10)
      created_droplet = client.droplets.find(id: created_droplet.id)
    end while created_droplet.status != 'active'

    created_droplet
  end

  private

  def user_data
    script_filename = File.join(Rails.root, "lib", "build.sh")

    <<~SCRIPT
      #!/usr/bin/bash
      HOST=#{ENV["SATURNCI_HOST"]}
      BUILD_ID=#{@build.id}
      GITHUB_INSTALLATION_ID=#{@github_installation_id}
      GITHUB_REPO_FULL_NAME=#{@build.project.github_repo_full_name}
      SATURNCI_API_USERNAME=#{ENV["SATURNCI_API_USERNAME"]}
      SATURNCI_API_PASSWORD=#{ENV["SATURNCI_API_PASSWORD"]}

      #{File.read(script_filename)}
    SCRIPT
  end
end
