

FactoryBot.define do
  factory :issue_priority do
    sequence(:name) { |n| "IssuePriority #{n}" }
  end

  factory :default_priority, parent: :issue_priority do
    is_default { true }
  end
end
