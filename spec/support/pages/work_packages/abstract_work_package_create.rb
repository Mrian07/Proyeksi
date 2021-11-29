

require 'support/pages/page'
require 'support/pages/work_packages/abstract_work_package'

module Pages
  class AbstractWorkPackageCreate < AbstractWorkPackage
    attr_reader :original_work_package,
                :project,
                :parent_work_package

    def initialize(original_work_package: nil, parent_work_package: nil, project: nil)
      # in case of copy, the original work package can be provided
      @project = project
      @original_work_package = original_work_package
      @parent_work_package = parent_work_package
    end

    def update_attributes(attribute_map)
      attribute_map.each do |label, value|
        work_package_field(label.downcase).set_value(value)
      end
    end

    def select_attribute(property, value)
      element = page.first(".inline-edit--container.#{property.downcase} select")

      element.select(value)
      element
    rescue Capybara::ExpectationNotMet
      nil
    end

    def expect_fully_loaded
      expect_angular_frontend_initialized
      expect(page).to have_selector '#wp-new-inline-edit--field-subject', wait: 20
    end

    def save!
      scroll_to_and_click find('.button', text: I18n.t('js.button_save'))
    end

    def cancel!
      scroll_to_and_click find('.button', text: I18n.t('js.button_cancel'))
    end
  end
end
