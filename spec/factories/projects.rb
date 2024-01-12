FactoryBot.define do
  factory :project do
    user
    saturn_installation
    name { "My Project" }
  end
end
