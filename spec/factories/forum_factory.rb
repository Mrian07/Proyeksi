

FactoryBot.define do
  factory :forum do
    project
    sequence(:name) { |n| "Forum No. #{n}" }
    sequence(:description) { |n| "I am the Forum No. #{n}" }
  end
end
