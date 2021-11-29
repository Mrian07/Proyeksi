

module Notifications
  class MailService
    include WithMarkedNotifications

    def initialize(notification)
      self.notification = notification
    end

    def call
      return unless supported?
      return if ian_read?

      with_marked_notifications(notification.id) do
        strategy.send_mail(notification)
      end
    end

    private

    attr_accessor :notification

    def ian_read?
      notification.read_ian
    end

    def strategy
      @strategy ||= if self.class.const_defined?("#{strategy_model}Strategy")
                      "#{self.class}::#{strategy_model}Strategy".constantize
                    end
    end

    def strategy_model
      journal&.journable_type || resource&.class
    end

    def journal
      notification.journal
    end

    def resource
      notification.resource
    end

    def supported?
      strategy.present?
    end

    def notification_marked_attribute
      :mail_alert_sent
    end
  end
end
