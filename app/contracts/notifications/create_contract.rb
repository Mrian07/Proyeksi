module Notifications
  class CreateContract < ::ModelContract
    attribute :recipient
    attribute :subject
    attribute :reason
    attribute :project
    attribute :actor
    attribute :resource
    attribute :journal
    attribute :resource_type
    attribute :read_ian
    attribute :mail_reminder_sent
    attribute :mail_alert_sent

    validate :validate_recipient_present
    validate :validate_reason_present
    validate :validate_read
    validate :validate_sent

    def validate_read
      errors.add(:read_ian, :read_on_creation) if model.read_ian
    end

    def validate_sent
      errors.add(:mail_reminder_sent, :set_on_creation) if model.mail_reminder_sent
      errors.add(:mail_alert_sent, :set_on_creation) if model.mail_alert_sent
    end

    def validate_recipient_present
      errors.add(:recipient, :blank) if model.recipient.blank?
    end

    def validate_reason_present
      errors.add(:reason, :no_notification_reason) if model.reason.nil?
    end
  end
end
