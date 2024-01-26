require "rails_helper"

describe "Project select", type: :system do
  let!(:project) { create(:project) }

  before do
    login_as(project.user, scope: :user)
  end

  context "there are no builds" do
    it "sets the select input to the project currently being visited" do
      visit project_path(project)
      expect(page).to have_select("project_id", selected: project.name)
    end
  end

  context "there is at least one build" do
    let!(:build) { create(:build, project: project) }

    it "sets the select input to the project currently being visited" do
      visit project_path(project)
      expect(page).to have_select("project_id", selected: project.name)
    end

    context "visiting system logs page" do
      it "sets the select input to the project currently being visited" do
        visit project_build_system_logs_path(build.project, build)
        expect(page).to have_select("project_id", selected: project.name)
      end
    end
  end
end
