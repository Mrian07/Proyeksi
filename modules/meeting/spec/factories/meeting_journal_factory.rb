

FactoryBot.define do
  factory :meeting_journal do
    created_at { Time.now }
    sequence(:version)

    factory :meeting_content_journal, class: 'Journal' do
      journable_type { 'MeetingContent' }
      activity_type { 'meetings' }
    end
  end
end
