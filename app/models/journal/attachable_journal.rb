#-- encoding: UTF-8

class Journal::AttachableJournal < Journal::AssociatedJournal
  self.table_name = 'attachable_journals'

  belongs_to :attachment
end
