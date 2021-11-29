

require 'support/pages/reminders/settings'

module Pages
  module My
    class Reminders < ::Pages::Reminders::Settings
      def path
        my_reminders_path
      end
    end
  end
end
