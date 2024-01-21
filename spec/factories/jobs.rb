FactoryBot.define do
  factory :job do
    build { nil }
    build_machine { nil }
    test_output { "MyText" }
    test_report { "MyText" }
    system_logs { "MyText" }
  end
end
