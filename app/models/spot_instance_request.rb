require "aws-sdk-ec2"

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
      BUILD_ID=#{@build.id}

      curl -X POST -d "type=spot_instance_ready" $HOST/api/v1/builds/$BUILD_ID/build_events

      sudo apt-get update
      sudo apt-get -y install ca-certificates curl gnupg
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg

      echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

      sudo apt-get update
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

      sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose

      TOKEN=$(curl -X POST $HOST/api/v1/github_tokens)
      PROJECT_DIR=/home/ubuntu/project
      git clone https://x-access-token:$TOKEN@github.com/jasonswett/mars $PROJECT_DIR
      curl -X POST -d "type=repository_cloned" $HOST/api/v1/builds/$BUILD_ID/build_events

      cd $PROJECT_DIR
      sudo docker-compose -f .saturnci/docker-compose.yml run app rails db:create
      curl -X POST -d "type=test_suite_started" $HOST/api/v1/builds/$BUILD_ID/build_events
      sudo docker-compose -f .saturnci/docker-compose.yml run app bundle exec rspec
      curl -X POST -d "type=test_suite_finished" $HOST/api/v1/builds/$BUILD_ID/build_events
    SCRIPT

    Base64.encode64(script_content)
  end
end
