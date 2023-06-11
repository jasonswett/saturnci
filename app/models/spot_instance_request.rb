class SpotInstanceRequest
  def initialize(build)
    @build = build
  end

  def send!
    ec2_client = Aws::EC2::Client.new(region: "us-east-2")
    ec2_client.request_spot_instances({
      dry_run: false,
      spot_price: "0.05",
      instance_count: 1,
      type: "one-time",
      launch_specification: {
        image_id: "ami-024e6efaf93d85776",
        instance_type: "t2.micro",
        key_name: "saturn",
        user_data: user_data
      }
    })
  end

  private

  def user_data
    script_filename = File.join(Rails.root, "app", "models", "spot_instance_script.rb")

    script_content = <<~SCRIPT
      #!/usr/bin/bash
      HOST="https://app.saturnci.com"
      curl -X POST -d "event=spot_instance_ready" $HOST/api/v1/builds/#{@build.id}/events
    SCRIPT

    Base64.encode64(script_content)
  end
end
