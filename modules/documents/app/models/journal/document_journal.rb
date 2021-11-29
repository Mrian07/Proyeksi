#-- encoding: UTF-8



class Journal::DocumentJournal < Journal::BaseJournal
  self.table_name = "document_journals"

  belongs_to :project
end
