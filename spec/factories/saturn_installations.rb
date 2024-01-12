FactoryBot.define do
  factory :saturn_installation do
    user
    github_installation_id { Faker::Number.number(digits: 8).to_s }
  end
end
