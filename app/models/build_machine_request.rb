require 'droplet_kit'

class BuildMachineRequest
  def initialize(build:, github_installation_id:)
    @build = build
    @github_installation_id = github_installation_id
  end

  def create!
    client = DropletKit::Client.new(access_token: ENV['DIGITALOCEAN_ACCESS_TOKEN'])

    droplet = DropletKit::Droplet.new(
      name: droplet_name,
      region: 'nyc1',
      image: 'ubuntu-20-04-x64',
      size: 's-4vcpu-8gb',
      user_data: user_data,
      tags: ['saturnci'],
      ssh_keys: []
    )

    client.droplets.create(droplet)
  end

  private

  def droplet_name
    "#{@build.project.name.gsub("/", "-")}-build-#{@build.id}"
  end

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
