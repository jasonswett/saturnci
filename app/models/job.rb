class Job < ApplicationRecord
  belongs_to :build
  has_many :job_events, dependent: :destroy

  def start!
    job_events.create!(type: :job_machine_requested)
    job_machine_request.create!
  end

  def job_machine_request
    JobMachineRequest.new(
      job: self,
      github_installation_id: build.project.saturn_installation.github_installation_id
    )
  end
end
