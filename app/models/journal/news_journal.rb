#-- encoding: UTF-8



class Journal::NewsJournal < Journal::BaseJournal
  self.table_name = 'news_journals'

  belongs_to :project
end
