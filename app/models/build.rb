class Build < ApplicationRecord
  belongs_to :project
  has_many :build_events, dependent: :destroy
  has_many :build_logs, dependent: :destroy
  alias_attribute :started_at, :created_at

  def start!
    transaction do
      save!
      build_events.create!(type: :build_machine_requested)
      build_machine_request.create!
    end
  end

  def status
    return "Running" if report.nil?
    return "Passed" if !report.include?("failed")
    "Failed"
  end

  def duration_formatted
    return unless duration.present?
    minutes = (duration / 60).floor
    seconds = (duration % 60).floor
    "#{minutes}m #{seconds}s"
  end

  def duration
    return unless ended_at.present?
    ended_at - started_at
  end

  def delete_build_machine
    client = DropletKit::Client.new(access_token: ENV['DIGITALOCEAN_ACCESS_TOKEN'])
    client.droplets.delete(id: build_machine_id)
  end

  private

  def ended_at
    test_suite_finished_event&.created_at
  end

  def test_suite_finished_event
    build_events.test_suite_finished.first
  end

  def build_machine_request
    BuildMachineRequest.new(
      build: self,
      github_installation_id: project.user.github_installation_id
    )
  end
end
