require "rails_helper"

describe "Build navigation", type: :system do
  let!(:build) { create(:build) }
  let!(:build_heading) { "Commit #{build.commit_hash[0..7]}" }

  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  describe "clicking build link" do
    before do
      visit project_path(build.project)
      click_on "build_link_#{build.id}"
    end

    it "keeps the left pane (build list)" do
      expect(page).to have_content(build_heading) # to prevent race condition
      expect(page).to have_content(build.project.name)
    end

    it "after refresh, keeps right pane (build detail)" do
      expect(page).to have_content(build_heading)
      visit current_url
      expect(page).to have_content(build_heading)
    end

    it "after refresh, keeps left pane (build list)" do
      expect(page).to have_content(build_heading)
      visit current_url
      expect(page).to have_content(build.project.name)
    end
  end
end
