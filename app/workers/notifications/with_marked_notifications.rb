#-- encoding: UTF-8



# Because we mark the notifications as read even though they in fact aren't, we do it in a transaction
# so that the change is rolled back in case of an error.
module Notifications
  module WithMarkedNotifications
    extend ActiveSupport::Concern

    included do
      private

      def with_marked_notifications(notification_ids)
        Notification.transaction do
          mark_notifications_sent(notification_ids)

          yield
        end
      end

      def mark_notifications_sent(notification_ids)
        Notification
          .where(id: Array(notification_ids))
          .update_all(notification_marked_attribute => true, updated_at: Time.current)
      end
    end
  end
end
