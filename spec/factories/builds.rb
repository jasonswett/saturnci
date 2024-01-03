FactoryBot.define do
  factory :build do
    project
    branch_name { "main" }
    author_name { Faker::Name.name }
    commit_hash { Faker::Alphanumeric.alphanumeric(number: 7) }
    commit_message { "Make change." }
  end
end
