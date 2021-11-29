

FactoryBot.define do
  factory :global_role do
    sequence(:name) { |n| "Global Role #{n}" }
  end
end
