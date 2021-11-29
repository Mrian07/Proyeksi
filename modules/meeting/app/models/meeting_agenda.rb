

class MeetingAgenda < MeetingContent
  def lock!(user = User.current)
    self.journal_notes = I18n.t('events.meeting_agenda_closed')
    self.author = user
    self.locked = true
    save
  end

  def unlock!(user = User.current)
    self.journal_notes = I18n.t('events.meeting_agenda_opened')
    self.author = user
    self.locked = false
    save
  end

  def editable?
    !locked?
  end
end
