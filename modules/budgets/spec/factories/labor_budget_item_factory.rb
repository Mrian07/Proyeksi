

FactoryBot.define do
  factory :labor_budget_item do
    association :user, factory: :user
    association :budget, factory: :budget
    hours { 0.0 }
  end
end
