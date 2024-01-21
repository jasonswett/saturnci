require "rails_helper"

RSpec.describe Job, type: :model do
  let!(:job) { create(:job) }

  describe "#start!" do
    it "creates a new job_event with type job_machine_requested" do
      expect { job.start! }
        .to change { JobEvent.where(type: "job_machine_requested").count }.by(1)
    end
  end
end
