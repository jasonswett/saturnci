require "rails_helper"

describe "Filter", type: :system do
  let!(:project) { create(:project) }

  before do
    create(:build, project: project, branch_name: "main")
    create(:build, project: project, branch_name: "filters")

    user = create(:user)
    login_as(user, scope: :user)
  end

  it "only shows builds from the main branch" do
    visit project_path(project)

    select "main", from: "branch_name"
    click_button "Apply"
    expect(page).not_to have_content("filters")
  end

  it "only shows builds from the main branch" do
    visit project_path(project)

    select "filters", from: "branch_name"
    click_button "Apply"
  end
end
