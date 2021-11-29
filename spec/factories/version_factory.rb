

FactoryBot.define do
  factory :version do
    sequence(:name) { |i| "Version #{i}" }
    effective_date { Date.today + 14.days }
    created_at { Time.now }
    updated_at { Time.now }
    project
  end
end
