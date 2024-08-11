require "rails_helper"

describe "Status filtering", type: :system do
  let!(:passed_job) { create(:job).finish! }

  let!(:failed_job) do
    create(
      :job,
      build: create(:build, project: passed_job.build.project)
    ).finish!
  end

  before do
    passed_job.build.update!(cached_status: "Passed")
    failed_job.build.update!(cached_status: "Failed")

    login_as(passed_job.build.project.user, scope: :user)
    visit job_path(passed_job, "test_output")
  end

  context "passed builds only" do
    it "includes the passed build" do
      check "Passed"
      click_on "Apply"

      within ".build-list" do
        expect(page).to have_content(passed_job.build.commit_hash)
      end
    end

    it "does not include the failed build" do
      check "Passed"
      click_on "Apply"

      within ".build-list" do
        expect(page).not_to have_content(failed_job.build.commit_hash)
      end
    end
  end

  context "failed builds only" do
    it "includes the failed build" do
      check "Failed"
      click_on "Apply"

      within ".build-list" do
        expect(page).to have_content(failed_job.build.commit_hash)
      end
    end

    it "does not include the passed build" do
      check "Failed"
      click_on "Apply"

      within ".build-list" do
        expect(page).not_to have_content(passed_job.build.commit_hash)
      end
    end
  end

  context "passed and failed builds" do
    it "includes the failed build" do
    end

    it "includes the passed build" do
    end
  end
end
