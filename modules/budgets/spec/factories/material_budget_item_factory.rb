

FactoryBot.define do
  factory :material_budget_item do
    association :cost_type, factory: :cost_type
    association :budget, factory: :budget
    units { 0.0 }
  end
end
