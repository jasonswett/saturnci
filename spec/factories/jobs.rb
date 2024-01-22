FactoryBot.define do
  factory :job do
    build
    job_machine_id { SecureRandom.hex(6) }
  end
end
