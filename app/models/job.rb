class Job < ApplicationRecord
  belongs_to :build
  has_many :job_events, dependent: :destroy
  alias_attribute :started_at, :created_at
  default_scope -> { order(:order_index) }

  def start!
    job_events.create!(type: :job_machine_requested)
    job_machine_request.create!
  end

  def status
    return "Running" if test_report.to_s.length == 0
    return "Passed" if !test_report.include?("failed")
    "Failed"
  end

  def job_machine_request
    JobMachineRequest.new(
      job: self,
      github_installation_id: build.project.saturn_installation.github_installation_id
    )
  end

  def delete_job_machine
    client = DropletKit::Client.new(access_token: ENV['DIGITALOCEAN_ACCESS_TOKEN'])
    client.droplets.delete(id: job_machine_id)
  end

  def duration
    return unless ended_at.present?
    ended_at - started_at
  end

  private

  def ended_at
    test_suite_finished_event&.created_at
  end

  def test_suite_finished_event
    job_events.test_suite_finished.first
  end
end
