#-- encoding: UTF-8



class Journal::MeetingJournal < Journal::BaseJournal
  self.table_name = 'meeting_journals'

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
end
