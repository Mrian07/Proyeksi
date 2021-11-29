

require 'support/pages/page'

module Pages
  module Projects
    class Settings < Pages::Page
      attr_accessor :project

      def initialize(project)
        super()

        self.project = project
      end

      def visit_tab!(name)
        visit "/projects/#{project.identifier}/settings/#{name}"
      end

      # only notice is used as opposed to op-toast
      def expect_toast(message:, type: :notice)
        expect(page).to have_selector(".flash.#{type}", text: message, wait: 10)
      end

      def expect_type_active(type)
        expect_type(type, true)
      end

      def expect_type_inactive(type)
        expect_type(type, false)
      end

      def expect_type(type, active = true)
        expect(page)
          .to have_field("project_planning_element_type_ids_#{type.id}", checked: active)
      end

      def expect_wp_custom_field_active(custom_field)
        expect_wp_custom_field(custom_field, true)
      end

      def expect_wp_custom_field_inactive(custom_field)
        expect_wp_custom_field(custom_field, false)
      end

      def activate_wp_custom_field(custom_field)
        check custom_field.name
      end

      def save!
        click_button 'Save'
      end

      def expect_wp_custom_field(custom_field, active = true)
        expect(page)
          .to have_field(custom_field.name, checked: active)
      end

      def fieldset_label
        find 'fieldset#project_issue_custom_fields label'
      end

      private

      def toast_type
        :rails
      end

      def path
        project_settings_general_path(project)
      end
    end
  end
end
