require "rails_helper"

RSpec.describe Build, type: :model do
  describe "#start!" do
    let(:project) { create(:project) } # Assuming that you have a Project factory
    let(:build) { Build.new(project: project) }
    let(:fake_spot_instance_request) { double("SpotInstanceRequest") }

    before do
      allow(build).to receive(:spot_instance_request).and_return(fake_spot_instance_request)
      allow(fake_spot_instance_request).to receive(:send!)
    end

    it "creates a new build_event with type spot_instance_requested" do
      expect { build.start! }
        .to change { BuildEvent.where(type: "spot_instance_requested").count }.by(1)
    end
  end
end
