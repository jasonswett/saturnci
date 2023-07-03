FactoryBot.define do
  factory :build do
    project
    branch_name { "main" }
    author_name { "George Washington" }
    commit_hash { "abc1234" }
    commit_message { "Make change." }
  end
end
