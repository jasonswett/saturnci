require "aws-sdk-ec2"

class Build < ApplicationRecord
  belongs_to :project
  has_many :build_events

  def self.start!(project)
    transaction do
      transaction do
        build = create!(project: project)
        SpotInstanceRequest.new(build).send!
      end
    end
  end
end
