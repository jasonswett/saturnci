class Build < ApplicationRecord
  NUMBER_OF_PARALLEL_JOBS = 2
  belongs_to :project
  has_many :jobs, dependent: :destroy
  has_many :build_events, dependent: :destroy
  has_many :build_logs, dependent: :destroy
  alias_attribute :started_at, :created_at

  after_initialize do
    self.seed ||= rand(10000)
  end

  def start!
    transaction do
      save!

      jobs_to_use.each do |job|
        job.save!
        job.start!
      end
    end
  end

  def status
    return "Running" unless jobs.any?
    return "Failed" if jobs.any? { |job| job.status == "Failed" }
    return "Passed" if jobs.all? { |job| job.status == "Passed" }
    "Running"
  end

  def jobs_to_use
    NUMBER_OF_PARALLEL_JOBS.times.map do |i|
      Job.new(build: self, order_index: i + 1)
    end
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

  def delete_job_machines
    jobs.each(&:delete_job_machine)
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
      github_installation_id: project.saturn_installation.github_installation_id
    )
  end
end
