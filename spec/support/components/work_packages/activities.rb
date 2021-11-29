

module Components
  module WorkPackages
    class Activities
      include Capybara::DSL
      include RSpec::Matchers

      attr_reader :work_package

      def initialize(work_package)
        @work_package = work_package
        @container = '.work-package-details-activities-list'
      end

      def expect_wp_has_been_created_activity(work_package)
        within @container do
          expect(page).to have_content("created on #{work_package.created_at.strftime('%m/%d/%Y')}")
        end
      end

      def hover_action(journal_id, action)
        retry_block do
          # Focus type edit to expose buttons
          activity = page.find("#activity-#{journal_id} .work-package-details-activities-activity-contents")
          page.driver.browser.action.move_to(activity.native).perform

          # Click the corresponding action button
          case action
          when :quote
            page.find("#activity-#{journal_id} .comments-icons .icon-quote").click
          end
        end
      end
    end
  end
end
