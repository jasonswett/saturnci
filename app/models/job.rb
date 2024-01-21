class Job < ApplicationRecord
  belongs_to :build
  has_many :job_events, dependent: :destroy

  def start!
    job_events.create!(type: :job_machine_requested)
  end
end
