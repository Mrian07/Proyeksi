

require 'support/pages/page'
require 'support/pages/work_packages/split_work_package'

module Pages
  module Notifications
    class SplitScreen < ::Pages::SplitWorkPackage
      include ::Components::NgSelectAutocompleteHelpers

      def initialize(work_package, project = nil)
        super work_package, project
        @selector = '.work-packages--details'
      end

      def expect_empty_state
        expect(page).to have_selector('[data-qa-selector="op-empty-state"]')
      end

      def expect_caught_up
        text = I18n.t('js.notifications.center.empty_state.no_notification')
        expect(page).to have_selector('[data-qa-selector="op-empty-state"]', text: text)
      end
    end
  end
end
