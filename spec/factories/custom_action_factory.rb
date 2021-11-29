

FactoryBot.define do
  factory :custom_action do
    sequence(:name) { |n| "Custom action #{n} - name" }
    sequence(:description) { |n| "Custom action #{n} - description" }
  end
end
