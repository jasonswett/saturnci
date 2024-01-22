require "rails_helper"

describe "Test output", type: :system do
  let!(:job) { create(:job, test_output: "this is the test output") }

  before do
    login_as(job.build.project.user, scope: :user)
  end

  it "is the default" do
    visit project_build_path(job.build.project, job.build)
    expect(page).to have_content("this is the test output")
  end
end
