require "rails_helper"

describe "Test output", type: :system do
  let!(:build) { create(:build, test_output: "this is the test output") }

  before do
    login_as(build.project.user, scope: :user)
  end

  it "is the default" do
    visit project_build_path(build.project, build)
    expect(page).to have_content("this is the test output")
  end
end
