

require 'support/pages/page'

module Pages
  module Notifications
    class Settings < ::Pages::Page
      include ::Components::NgSelectAutocompleteHelpers

      attr_reader :user

      def initialize(user)
        @user = user
        super()
      end

      def path
        edit_user_path(user, tab: :notifications)
      end

      def expect_represented
        user.notification_settings.each do |setting|
          expect_global_represented(setting)
          # expect_project_represented(setting)
        end
      end

      def expect_global_represented(setting)
        %i[
          involved
          work_package_commented
          work_package_created
          work_package_processed
          work_package_prioritized
          work_package_scheduled
        ].each do |type|
          expect(page).to have_selector("input[type='checkbox'][data-qa-global-notification-type='#{type}']") do |checkbox|
            checkbox.checked? == setting[type]
          end
        end
      end

      def expect_project(project)
        expect(page).to have_selector('th', text: project.name)
      end

      def add_project(project)
        click_button 'Add setting for project'
        container = page.find('[data-qa-selector="notification-setting-inline-create"] ng-select')
        select_autocomplete container, query: project.name, results_selector: 'body'
        expect_project project
      end

      def configure_global(**types)
        types.each(&method(:set_global_option))
      end

      def set_global_option(type, checked)
        checkbox = page.find "input[type='checkbox'][data-qa-global-notification-type='#{type}']"
        checked ? checkbox.check : checkbox.uncheck
      end

      def configure_project(project: nil, **types)
        types.each { |type| set_project_option(*type, project) }
      end

      def set_project_option(type, checked, project)
        checkbox = page.find "input[type='checkbox'][data-qa-project='#{project}'][data-qa-project-notification-type='#{type}']"
        checked ? checkbox.check : checkbox.uncheck
      end

      def save
        click_button 'Save'
        expect_toast message: 'Successful update.'
      end
    end
  end
end
