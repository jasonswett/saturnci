require "rails_helper"

describe "Duration", type: :system do
  it "displays the build duration" do
    project = create(:project)
    build = create(:build, project: project)

    create(
      :build_event,
      type: :test_suite_finished,
      build: build,
      created_at: build.created_at + ((5 * 60) + 10).seconds
    )

    visit project_path(project)

    binding.pry
    expect(page).to have_content("5m 10s")
  end
end