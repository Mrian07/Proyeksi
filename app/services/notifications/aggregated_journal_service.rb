#-- encoding: UTF-8

class Notifications::AggregatedJournalService
  ##
  # Move existing notifications for aggregated events over
  # if they have an immediate response associated
  def self.relocate_immediate(journal:, predecessor:)
    Notification
      .where(journal_id: predecessor.id)
      .where(reason: :mentioned)
      .update_all(journal_id: journal.id, read_ian: false)
  end
end
