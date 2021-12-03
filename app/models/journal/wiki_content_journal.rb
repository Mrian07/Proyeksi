#-- encoding: UTF-8

class Journal::WikiContentJournal < Journal::BaseJournal
  self.table_name = 'wiki_content_journals'

  # The project does not change over the course of a wiki content lifetime
  delegate :project, to: :journal
end
