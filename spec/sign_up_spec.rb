require "rails_helper"

RSpec.describe "Sign up with Github", type: :system do
  context "success" do
    it "redirects to projects page" do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        provider: "github",
        uid: "123545",
        info: {
          email: "test@example.com",
          name: "John Smith"
        },
        credentials: {
          token: "mock_token_123"
        }
      )

      visit new_user_registration_path
      click_on "Sign up with GitHub"
      
      expect(page).to have_content("blah")
    end
  end
end
