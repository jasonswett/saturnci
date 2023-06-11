class Build < ApplicationRecord
  belongs_to :project
  has_many :build_events

  def start!
    transaction do
      save!
      build_events.create!(type: :spot_instance_requested)
      spot_instance_request.send!
    end
  end

  private

  def spot_instance_request
    SpotInstanceRequest.new(self)
  end
end
