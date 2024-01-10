require "rails_helper"

describe "Delete build", type: :system do
  let!(:build) { create(:build) }

  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  context "main branch" do
    it "only shows builds from the main branch" do
      visit project_build_path(id: build.id, project_id: build.project.id)
      click_on "Delete"
      expect(page).not_to have_content(build.commit_hash)
    end
  end
end
