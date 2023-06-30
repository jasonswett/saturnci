require "rails_helper"

RSpec.describe Build, type: :model do
  let!(:build) { create(:build) }

  describe "#start!" do
    let!(:fake_spot_instance_request) { double("SpotInstanceRequest") }

    before do
      allow(build).to receive(:spot_instance_request).and_return(fake_spot_instance_request)
      allow(fake_spot_instance_request).to receive(:create!)
    end

    it "creates a new build_event with type spot_instance_requested" do
      expect { build.start! }
        .to change { BuildEvent.where(type: "spot_instance_requested").count }.by(1)
    end
  end

  describe "#status" do
    context "there's no report yet" do
      it "returns 'Running'" do
        expect(build.status).to eq("Running")
      end
    end

    context "report is an empty array" do
      it "returns 'Passed'" do
        build.update!(report: [])
        expect(build.status).to eq("Passed")
      end
    end

    context "report is anything else" do
      it "returns 'Failed'" do
      end
    end
  end
end
