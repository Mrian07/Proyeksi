

require 'support/pages/notifications/settings'

module Pages
  module My
    class Notifications < ::Pages::Notifications::Settings
      def path
        my_notifications_path
      end
    end
  end
end
