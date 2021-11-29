#-- encoding: UTF-8



##
# Create journal for the given user and note.
# Does not change the work package itself.

class AddWorkPackageNoteService
  include Contracted
  attr_accessor :user, :work_package

  def initialize(user:, work_package:)
    self.user = user
    self.work_package = work_package
    self.contract_class = WorkPackages::CreateNoteContract
  end

  def call(notes, send_notifications: true)
    Journal::NotificationConfiguration.with send_notifications do
      work_package.add_journal(user, notes)

      success, errors = validate_and_yield(work_package, user) do
        work_package.save_journals
      end

      journal = work_package.journals.last if success
      ServiceResult.new(success: success, result: journal, errors: errors)
    end
  end
end
