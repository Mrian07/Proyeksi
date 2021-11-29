#-- encoding: UTF-8



class Journal::MessageJournal < Journal::BaseJournal
  self.table_name = 'message_journals'

  belongs_to :forum
  has_one :project, through: :forum
end
