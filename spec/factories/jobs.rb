FactoryBot.define do
  factory :job do
    build
    order_index { 1 }
    job_machine_id { SecureRandom.hex(6) }
  end
end
