

FactoryBot.define do
  factory :status do
    sequence(:name) { |n| "status #{n}" }
    is_closed { false }
    is_readonly { false }

    factory :closed_status do
      is_closed { true }
    end

    factory :default_status do
      is_default { true }
    end
  end
end
