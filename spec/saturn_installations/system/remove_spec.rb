require "rails_helper"

describe "Remove installation", type: :system do
  let!(:saturn_installation) { create(:saturn_installation) }

  before do
    login_as(saturn_installation.user, scope: :user)
  end

  it "deletes the installation" do
    visit saturn_installations_path
    click_on "Remove"

    expect(page).not_to have_content(saturn_installation.github_installation_id)
  end
end
