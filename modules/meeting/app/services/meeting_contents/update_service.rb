#-- encoding: UTF-8



module MeetingContents
  class UpdateService < ::BaseServices::Update
    include Attachments::ReplaceAttachments

    def persist(call)
      content = call.result

      if content.lock_version_changed?
        call.errors.add(:base, I18n.t(:notice_locking_conflict))
        call.success = false
        return call
      end

      super
    end
  end
end
