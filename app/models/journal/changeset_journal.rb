#-- encoding: UTF-8

class Journal::ChangesetJournal < Journal::BaseJournal
  self.table_name = 'changeset_journals'
end
