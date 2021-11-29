

FactoryBot.define do
  factory :meeting do |m|
    author factory: :user
    project
    start_time { Date.tomorrow + 10.hours }
    duration { 1.0 }
    m.sequence(:title) { |n| "Meeting #{n}" }

    after(:create) do |meeting, evaluator|
      meeting.project = evaluator.project if evaluator.project
    end
  end
end
