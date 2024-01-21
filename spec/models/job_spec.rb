require "rails_helper"

RSpec.describe Job, type: :model do
  let!(:job) { create(:job) }

  before do
    fake_job_machine_request = double("JobMachineRequest")
    allow(job).to receive(:job_machine_request).and_return(fake_job_machine_request)
    allow(fake_job_machine_request).to receive(:create!)
  end

  describe "#start!" do
    it "creates a new job_event with type job_machine_requested" do
      expect { job.start! }
        .to change { JobEvent.where(type: "job_machine_requested").count }.by(1)
    end
  end
end
