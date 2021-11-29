

FactoryBot.define do
  factory :journal_changeset_journal, class: 'Journal::ChangesetJournal' do
    revision { 5 }
    committed_on { Time.zone.today }
  end
end
