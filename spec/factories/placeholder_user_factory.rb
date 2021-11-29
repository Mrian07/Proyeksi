

FactoryBot.define do
  factory :placeholder_user, parent: :principal, class: 'PlaceholderUser' do
    sequence(:name) { |n| "UX Designer #{n}" }
  end
end
