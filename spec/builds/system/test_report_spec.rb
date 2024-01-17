require "rails_helper"

describe "Test report", type: :system do
  let!(:build) { create(:build, report: "this is the test report") }

  before do
    login_as(build.project.user, scope: :user)
  end

  it "is the default" do
    visit project_build_path(build.project, build)
    expect(page).to have_content("this is the test report")
  end
end
