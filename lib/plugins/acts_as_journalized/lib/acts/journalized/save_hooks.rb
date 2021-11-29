

# These hooks make sure journals are properly created and updated with Redmine user detail,
# notes and associated custom fields
module Acts::Journalized
  module SaveHooks
    def self.included(base)
      base.class_eval do
        after_save :save_journals

        attr_accessor :journal_notes, :journal_user
      end
    end

    def save_journals
      with_ensured_journal_attributes do
        create_call = Journals::CreateService
                      .new(self, @journal_user)
                      .call(notes: @journal_notes)

        if create_call.success? && create_call.result
          OpenProject::Notifications.send(OpenProject::Events::JOURNAL_CREATED,
                                          journal: create_call.result,
                                          send_notification: Journal::NotificationConfiguration.active?)
        end

        create_call.success?
      end
    end

    def add_journal(user = User.current, notes = '')
      self.journal_user ||= user
      self.journal_notes ||= notes
    end

    private

    def with_ensured_journal_attributes
      self.journal_user ||= User.current
      self.journal_notes ||= ''

      yield
    ensure
      self.journal_user = nil
      self.journal_notes = nil
    end
  end
end
