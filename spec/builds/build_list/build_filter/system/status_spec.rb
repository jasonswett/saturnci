require "rails_helper"

describe "Status filtering", type: :system do
  let!(:passed_job) { create(:job) }

  let!(:failed_job) do
    create(:job, build: create(:build, project: passed_job.build.project))
  end

  before do
    login_as(passed_job.build.project.user, scope: :user)
  end

  context "passed builds only" do
    it "includes the passed build" do
      visit job_path(passed_job, "test_output")
      check "Passed"
      click_on "Apply"
      expect(page).to have_content(passed_job.build.commit_hash)
    end

    it "does not includes the failed build" do
      visit job_path(passed_job, "test_output")
      check "Failed"
      click_on "Apply"
      expect(page).not_to have_content(failed_job.build.commit_hash)
    end
  end

  context "failed builds only" do
    it "includes the failed build" do
    end

    it "does not include the passed build" do
    end
  end

  context "passed and failed builds" do
    it "includes the failed build" do
    end

    it "includes the passed build" do
    end
  end
end
