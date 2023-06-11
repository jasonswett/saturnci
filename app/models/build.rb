require "aws-sdk-ec2"

class Build < ApplicationRecord
  belongs_to :project

  def self.start!(project)
    transaction do
      create!(project: project)

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
          user_data: Base64.encode64("#!/bin/bash -ex\necho Hello, World!")
        }
      })
    end
  end
end
