

FactoryBot.define do
  factory :cost_type do
    sequence(:name) { |n| "ct no. #{n}" }
    unit { 'singular_unit' }
    unit_plural { 'plural_unit' }

    trait :deleted do
      deleted_at { Time.now }
    end
  end
end
