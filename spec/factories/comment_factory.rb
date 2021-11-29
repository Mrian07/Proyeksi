

FactoryBot.define do
  factory :comment do
    author factory: :user
    sequence(:comments) { |n| "I am a comment No. #{n}" }
    commented factory: :news
  end
end
