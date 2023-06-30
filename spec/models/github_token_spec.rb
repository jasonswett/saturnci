require "rails_helper"

RSpec.describe GitHubToken, type: :model do
  context "when installation id is present" do
    it "does not raise an error" do
      allow(GitHubToken).to receive(:token)

      expect { GitHubToken.generate("123456") }.not_to raise_error
    end
  end

  context "when installation id is missing" do
    it "raises an error" do
      allow(GitHubToken).to receive(:token)

      expect { GitHubToken.generate(nil) }.to raise_error(RuntimeError, "Installation ID is missing")
    end
  end
end
