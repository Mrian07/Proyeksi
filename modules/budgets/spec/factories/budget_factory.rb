

FactoryBot.define do
  factory :budget do
    sequence(:subject) { |n| "Budget No. #{n}" }
    sequence(:description) { |n| "I am Budget No. #{n}" }
    project
    association :author, factory: :user
    fixed_date { Date.today }
    created_at { 3.days.ago }
    updated_at { 3.days.ago }
  end
end
