

FactoryBot.define do
  factory :journal do
    user factory: :user
    created_at { Time.now }
    sequence(:version, 1)

    factory :work_package_journal, class: 'Journal' do
      journable_type { 'WorkPackage' }
      activity_type { 'work_packages' }
      data { FactoryBot.build(:journal_work_package_journal) }

      callback(:after_stub) do |journal, options|
        journal.journable ||= options.journable || FactoryBot.build_stubbed(:work_package)
      end
    end

    factory :wiki_content_journal, class: 'Journal' do
      journable_type { 'WikiContent' }
      activity_type { 'wiki_edits' }
      data { FactoryBot.build(:journal_wiki_content_journal) }
    end

    factory :message_journal, class: 'Journal' do
      journable_type { 'Message' }
      activity_type { 'messages' }
      data { FactoryBot.build(:journal_message_journal) }
    end

    factory :news_journal, class: 'Journal' do
      journable_type { 'News' }
      activity_type { 'news' }
      data { FactoryBot.build(:journal_message_journal) }
    end
  end
end
