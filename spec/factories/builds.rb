FactoryBot.define do
  factory :build do
    project
    commit { "abc1234" }
  end
end
