

module Pages
  module Notifications
    class Center < ::Pages::Page

      def open
        bell_element.click
        expect_open
      end

      def path
        notifications_center_path
      end

      def close
        page.find('button[data-qa-selector="op-back-button"]').click
        expect_closed
      end

      def mark_all_read
        click_button 'Mark all as read'
      end

      def mark_notification_as_read(notification)
        within_item(notification) do
          page.find('[data-qa-selector="mark-as-read-button"]').click
        end
      end

      def show_all
        click_button 'All'
      end

      def click_item(notification)
        text = notification.resource.is_a?(WorkPackage) ? notification.resource.subject : notification.subject
        within_item(notification) do
          page.find('span', text: text, exact_text: true).click
        end
      end

      def within_item(notification, &block)
        page.within("[data-qa-selector='op-ian-notification-item-#{notification.id}']", &block)
      end

      def expect_item(notification, subject: notification.subject)
        within_item(notification) do
          expect(page).to have_text subject, normalize_ws: true
        end
      end

      def expect_no_item(*notifications)
        notifications.each do |notification|
          expect(page)
            .to have_no_selector("[data-qa-selector='op-ian-notification-item-#{notification.id}']")
        end
      end

      def expect_read_item(notification)
        expect(page)
          .to have_selector("[data-qa-selector='op-ian-notification-item-#{notification.id}'][data-qa-ian-read]")
      end

      def expect_item_not_read(notification)
        expect(page)
          .not_to have_selector("[data-qa-selector='op-ian-notification-item-#{notification.id}'][data-qa-ian-read]")
      end

      def expect_item_selected(notification)
        expect(page)
          .to have_selector("[data-qa-selector='op-ian-notification-item-#{notification.id}'][data-qa-ian-selected]")
      end

      def expect_work_package_item(*notifications)
        notifications.each do |notification|
          work_package = notification.resource
          raise(ArgumentError, "Expected work package") unless work_package.is_a?(WorkPackage)

          expect_item notification,
                      subject: "#{work_package.type.name.upcase} #{work_package.subject}"
        end
      end

      def expect_closed
        expect(page).to have_no_selector('op-in-app-notification-center')
      end

      def expect_open
        expect(page).to have_selector('op-in-app-notification-center')
      end

      def expect_empty
        expect(page).to have_text 'New notifications will appear here when there is activity that concerns you'
      end

      def expect_number_of_notifications(count)
        if count == 0
          expect(page).to have_no_selector('[data-qa-selector^="op-ian-notification-item-"]')
        else
          expect(page).to have_selector('[data-qa-selector^="op-ian-notification-item-"]', count: count, wait: 10)
        end
      end

      def expect_bell_count(count)
        if count == 0
          expect(page).to have_no_selector('[data-qa-selector="op-ian-notifications-count"]')
        else
          expect(page).to have_selector('[data-qa-selector="op-ian-notifications-count"]', text: count, wait: 10)
        end
      end

      def bell_element
        page.find('op-in-app-notification-bell [data-qa-selector="op-ian-bell"]')
      end

      def expect_no_toaster
        expect(page).to have_no_selector('.op-toast.-info', wait: 10)
      end

      def expect_toast
        expect(page).to have_selector('.op-toast.-info', wait: 10)
      end

      def update_via_toaster
        page.find('.op-toast.-info a', wait: 10).click
      end
    end
  end
end
