#-- encoding: UTF-8



class Journals::CompletedJob < ApplicationJob
  queue_with_priority :notification

  class << self
    def schedule(journal, send_mails)
      return unless supported?(journal)

      set(wait_until: delivery_time)
        .perform_later(journal.id, send_mails)
    end

    def aggregated_event(journal)
      case journal.journable_type
      when WikiContent.name
        ProyeksiApp::Events::AGGREGATED_WIKI_JOURNAL_READY
      when WorkPackage.name
        ProyeksiApp::Events::AGGREGATED_WORK_PACKAGE_JOURNAL_READY
      when News.name
        ProyeksiApp::Events::AGGREGATED_NEWS_JOURNAL_READY
      when Message.name
        ProyeksiApp::Events::AGGREGATED_MESSAGE_JOURNAL_READY
      end
    end

    private

    def delivery_time
      Setting.journal_aggregation_time_minutes.to_i.minutes.from_now
    end

    def supported?(journal)
      aggregated_event(journal).present?
    end
  end

  def perform(journal_id, send_mails)
    journal = Journal.find_by(id: journal_id)

    # If the WP has been deleted the journal will have been deleted, too.
    # Or the journal might have been replaced
    return if journal.nil?

    notify_journal_complete(journal, send_mails)
  end

  private

  def notify_journal_complete(journal, send_mails)
    ProyeksiApp::Notifications.send(self.class.aggregated_event(journal),
                                    journal: journal,
                                    send_mail: send_mails)
  end
end
