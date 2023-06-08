require "aws-sdk-ec2"  # v2: require "aws-sdk"

namespace :build do
  task invoke: :environment do
    ec2 = Aws::EC2::Client.new(region: "us-east-2")

    begin
      ec2.request_spot_instances({
        dry_run: false,
        spot_price: "0.05",
        instance_count: 1,
        type: "one-time",
        launch_specification: {
          image_id: "ami-024e6efaf93d85776",
          instance_type: "t2.micro",
          key_name: "saturn",
          user_data: Base64.encode64("#!/bin/bash -ex\necho Hello, World!")
        }
      })

      puts "Successfully requested spot instance."

    rescue Aws::EC2::Errors::ServiceError => error
      puts "Error requesting spot instance: #{error}"
    end
  end
end
