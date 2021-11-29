

FactoryBot.define do
  factory :message do
    forum
    sequence(:content) { |n| "Message content #{n}" }
    sequence(:subject) { |n| "Message subject #{n}" }
  end
end
