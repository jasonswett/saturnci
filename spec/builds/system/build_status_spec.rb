require "rails_helper"

describe "Build status", type: :system do
  let!(:build) { create(:build) }

  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  context "build goes from running to passed" do
    it "shows the most current status" do
      visit project_build_path(id: build.id, project_id: build.project.id)
      expect(page).to have_content("Running")

      create(:job, build: build, test_report: "good")

      visit project_build_path(id: build.id, project_id: build.project.id)
      expect(page).to have_content("Passed")
    end
  end
end
