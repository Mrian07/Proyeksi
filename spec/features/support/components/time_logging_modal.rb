

module Components
  class TimeLoggingModal
    include Capybara::DSL
    include RSpec::Matchers

    attr_reader :activity_field,
                :comment_field,
                :hours_field,
                :spent_on_field,
                :work_package_field

    def initialize
      @activity_field = EditField.new(page, 'activity')
      @comment_field = EditField.new(page, 'comment')
      @hours_field = EditField.new(page, 'hours')
      @spent_on_field = EditField.new(page, 'spentOn')
      @work_package_field = EditField.new(page, 'workPackage')
    end

    def is_visible(visible)
      if visible
        within modal_container do
          expect(page)
            .to have_text(I18n.t('js.button_log_time'))
        end
      else
        expect(page).to have_no_selector '.op-modal'
      end
    end

    def has_field_with_value(field, value)
      within modal_container do
        expect(page).to have_field field_identifier(field), with: value
      end
    end

    def shows_field(field, visible)
      within modal_container do
        if visible
          expect(page).to have_selector "##{field_identifier(field)}"
        else
          expect(page).to have_no_selector "##{field_identifier(field)}"
        end
      end
    end

    def update_field(field_name, value)
      field = field_object field_name
      field.input_element.click
      field.set_value value
    end

    def update_work_package_field(value, recent = false)
      work_package_field.input_element.click

      if recent
        within('.ng-dropdown-header') do
          click_link(I18n.t('js.label_recent'))
        end
      end

      work_package_field.set_value(value)
    end

    def perform_action(action)
      within modal_container do
        click_button action
      end
    end

    def work_package_is_missing(missing)
      if missing
        expect(page)
          .to have_content(I18n.t('js.time_entry.work_package_required'))
      else
        expect(page)
          .to have_no_content(I18n.t('js.time_entry.work_package_required'))
      end
    end

    private

    def field_identifier(field_name)
      case field_name
      when 'spent_on'
        'wp-new-inline-edit--field-spentOn'
      when 'work_package'
        'wp-new-inline-edit--field-workPackage'
      end
    end

    def field_object(field_name)
      case field_name
      when 'activity'
        activity_field
      when 'hours'
        hours_field
      when 'spent_on'
        spent_on_field
      when 'comment'
        comment_field
      when 'work_package'
        work_package_field
      end
    end

    def modal_container
      page.find('.op-modal')
    end
  end
end
