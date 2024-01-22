require 'droplet_kit'

class JobMachineRequest
  def initialize(job:, github_installation_id:)
    @job = job
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

    droplet_request = client.droplets.create(droplet)
    @job.update!(job_machine_id: droplet_request.id)
  end

  private

  def droplet_name
    "#{@job.build.project.name.gsub("/", "-")}-job-#{@job.id}"
  end

  def user_data
    script_filename = File.join(Rails.root, "lib", "job.sh")

    <<~SCRIPT
      #!/usr/bin/bash
      HOST=#{ENV["SATURNCI_HOST"]}
      JOB_ID=#{@job.id}
      JOB_ORDER_INDEX=#{@job.order_index}
      COMMIT_HASH=#{@job.build.commit_hash}
      RSPEC_SEED=#{rand(10000)}
      GITHUB_INSTALLATION_ID=#{@github_installation_id}
      GITHUB_REPO_FULL_NAME=#{@job.build.project.github_repo_full_name}
      SATURNCI_API_USERNAME=#{ENV["SATURNCI_API_USERNAME"]}
      SATURNCI_API_PASSWORD=#{ENV["SATURNCI_API_PASSWORD"]}

      #{File.read(script_filename)}
    SCRIPT
  end
end
