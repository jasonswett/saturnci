require "aws-sdk-ec2"

class SpotInstanceRequest
  def initialize(build:, github_installation_id:)
    @build = build
    @github_installation_id = github_installation_id
  end

  def create!
    ec2_client = Aws::EC2::Client.new(region: "us-east-2")
    response = ec2_client.request_spot_instances({
      dry_run: false,
      spot_price: "0.05",
      instance_count: 1,
      type: "one-time",
      launch_specification: {
        image_id: "ami-024e6efaf93d85776",
        instance_type: "t3.medium",
        key_name: "saturn",
        user_data: user_data
      }
    })

    request_id = response.spot_instance_requests.first.spot_instance_request_id

    ec2_client.wait_until(
      :spot_instance_request_fulfilled,
      spot_instance_request_ids: [request_id]
    )

    response_after_fulfillment = ec2_client.describe_spot_instance_requests({
      spot_instance_request_ids: [request_id]
    })

    instance_id = response_after_fulfillment.spot_instance_requests.first.instance_id

    ec2_client.create_tags({
      resources: [instance_id],
      tags: [{
        key: 'Name',
        value: "#{ENV["RAILS_ENV"]}-#{@build.id}"
      }]
    })
  end

  private

  # Run curl http://169.254.169.254/latest/user-data on the
  # spot instance to see the contents of the script
  def user_data
    script_filename = File.join(Rails.root, "app", "models", "spot_instance_script.rb")

    script_content = <<~SCRIPT
      #!/usr/bin/bash
      HOST=#{ENV["SATURNCI_HOST"]}
      BUILD_ID=#{@build.id}
      GITHUB_INSTALLATION_ID=#{@github_installation_id}
      GITHUB_REPO_FULL_NAME=#{@build.project.github_repo_full_name}
      SATURNCI_API_USERNAME=#{ENV["SATURNCI_API_USERNAME"]}
      SATURNCI_API_PASSWORD=#{ENV["SATURNCI_API_PASSWORD"]}

      #{File.read(Rails.root.join("lib", "build.sh"))}
    SCRIPT

    Base64.encode64(script_content)
  end
end
