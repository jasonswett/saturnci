require "rails_helper"

RSpec.describe "rebuilds", type: :request do
  describe "POST rebuilds" do
    let!(:build) do
      create(:build) do |build|
        build.project.user.saturn_installations.create!(
          github_installation_id: "123456"
        )
      end
    end

    before do
      build_machine_request_double = instance_double(BuildMachineRequest)
      allow(BuildMachineRequest).to receive(:new).and_return(build_machine_request_double)
      allow(build_machine_request_double).to receive(:create!)
    end

    it "increases the count of builds by 1" do
      login_as(build.project.user, scope: :user)

      expect {
        post(rebuilds_path(build_id: build.id))
      }.to change(Build, :count).by(1)
    end
  end
end
