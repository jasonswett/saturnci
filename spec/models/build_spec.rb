require "rails_helper"

RSpec.describe Build, type: :model do
  let!(:job) { create(:job) }
  let!(:build) { job.build }

  describe "#start!" do
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
    context "there's no report yet" do
      it "returns 'Running'" do
        expect(build.status).to eq("Running")
      end
    end

    context "report is empty" do
      it "returns 'Running'" do
        build.update!(report: "")
        expect(build.status).to eq("Running")
      end
    end

    context "report is success" do
      it "returns 'Passed'" do
        build.update!(report: success)
        expect(build.status).to eq("Passed")
      end
    end

    context "report is failure" do
      it "returns 'Failed'" do
        build.update!(report: failure)
        expect(build.status).to eq("Failed")
      end
    end
  end

  def success
    <<~RESULTS
example_id                                                 | status | run_time        |
---------------------------------------------------------- | ------ | --------------- |
./spec/models/github_token_spec.rb[1:2:1]                  | passed | 0.00288 seconds |
./spec/rebuilds_spec.rb[1:1:1]                             | passed | 0.04704 seconds |
./spec/sign_up_spec.rb[1:1:1]                              | passed | 0.1331 seconds  |
./spec/test_spec.rb[1:1]                                   | passed | 0.00798 seconds |
    RESULTS
  end

  def failure
    <<~RESULTS
example_id                                                 | status | run_time        |
---------------------------------------------------------- | ------ | --------------- |
./spec/models/github_token_spec.rb[1:2:1]                  | passed | 0.00288 seconds |
./spec/rebuilds_spec.rb[1:1:1]                             | passed | 0.04704 seconds |
./spec/sign_up_spec.rb[1:1:1]                              | passed | 0.1331 seconds  |
./spec/test_spec.rb[1:1]                                   | failed | 0.00798 seconds |
    RESULTS
  end
end
