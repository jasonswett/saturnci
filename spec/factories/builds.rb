FactoryBot.define do
  factory :build do
    project
    commit_hash { "abc1234" }
    commit_message { "Make change." }
  end
end
