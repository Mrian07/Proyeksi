

FactoryBot.define do
  factory :custom_option do
    sequence(:value) { |n| "Custom Option #{n}" }
  end
end
