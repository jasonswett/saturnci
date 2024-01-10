require "rails_helper"

describe "Delete build", type: :system do
  let!(:build) { create(:build) }

  before do
    stub_request(:delete, "https://api.digitalocean.com/v2/droplets").to_return(status: 200)

    user = create(:user)
    login_as(user, scope: :user)
  end

  context "branch is only branch" do
    it "removes the build" do
      visit project_build_path(id: build.id, project_id: build.project.id)
      click_on "Delete"
      expect(page).not_to have_content(build.commit_hash)
    end
  end

  context "branch is not the only branch" do
    it "removes the build" do
      create(:build, project: build.project)

      visit project_build_path(id: build.id, project_id: build.project.id)
      click_on "Delete"
      expect(page).not_to have_content(build.commit_hash)
    end
  end
end
