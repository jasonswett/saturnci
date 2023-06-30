FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8) }

    trait :with_saturn_installation do
      after(:create) do |user|
        user.saturn_installations.create!(
          github_installation_id: "123456"
        )
      end
    end
  end
end
