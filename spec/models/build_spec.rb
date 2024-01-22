require "rails_helper"

RSpec.describe Build, type: :model do
  describe "#start!" do
    let!(:job) { create(:job) }
    let!(:build) { job.build }

    before do
      fake_job_machine_request = double("JobMachineRequest")
      allow(job).to receive(:job_machine_request).and_return(fake_job_machine_request)
      allow(fake_job_machine_request).to receive(:create!)

      fake_build_machine_request = double("BuildMachineRequest")
      allow(build).to receive(:jobs_to_use).and_return([job])
      allow(build).to receive(:build_machine_request).and_return(fake_build_machine_request)
      allow(fake_build_machine_request).to receive(:create!)
    end

    it "creates a new job_event with type job_machine_requested" do
      expect { build.start! }
        .to change { JobEvent.where(type: "job_machine_requested").count }.by(1)
    end
  end

  describe "#status" do
    let!(:build) { create(:build) }

    context "all jobs have passed" do
      it "is passed" do
        job_1 = create(:job, build: build)
        job_2 = create(:job, build: build)
        allow(job_1).to receive(:status).and_return("Passed")
        allow(job_2).to receive(:status).and_return("Passed")
        allow(build).to receive(:jobs).and_return([job_1, job_2])

        expect(build.status).to eq("Passed")
      end
    end

    context "any jobs have failed" do
      it "is failed" do
        job_1 = create(:job, build: build)
        job_2 = create(:job, build: build)
        allow(job_1).to receive(:status).and_return("Passed")
        allow(job_2).to receive(:status).and_return("Failed")
        allow(build).to receive(:jobs).and_return([job_1, job_2])

        expect(build.status).to eq("Failed")
      end
    end

    context "some jobs are running, no jobs are failed" do
      it "is running" do
        job_1 = create(:job, build: build)
        job_2 = create(:job, build: build)
        allow(job_1).to receive(:status).and_return("Passed")
        allow(job_2).to receive(:status).and_return("Running")
        allow(build).to receive(:jobs).and_return([job_1, job_2])

        expect(build.status).to eq("Running")
      end
    end

    context "there are no jobs" do
      it "is running" do
        allow(build).to receive(:jobs).and_return([])

        expect(build.status).to eq("Running")
      end
    end
  end
end
