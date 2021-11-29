#-- encoding: UTF-8



class Journal::MeetingContentJournal < Journal::BaseJournal
  self.table_name = 'meeting_content_journals'

  belongs_to :meeting
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  def editable?
    false
  end
end
