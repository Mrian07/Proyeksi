

require 'support/pages/page'
require 'support/components/ng_select_autocomplete_helpers'

module Pages
  module Admin
    module CustomActions
      class Form < ::Pages::Page
        include ::Components::NgSelectAutocompleteHelpers

        def set_name(name)
          fill_in 'Name', with: name
        end

        def set_description(description)
          fill_in 'Description', with: description
        end

        def add_action(name, value)
          sleep 1
          select name, from: 'Add action'
          sleep 1
          set_action_value(name, value)
          sleep 1
          page.assert_selector('#custom-actions-form--active-actions .form--label', text: name)
        end

        def remove_action(name)
          within '#custom-actions-form--active-actions' do
            find('.form--field', text: name)
              .find('.icon-close')
              .click
          end
        end

        def expect_selected_option(value)
          expect(page).to have_selector('.ng-value-label', text: value)
        end

        def expect_action(name, value)
          value = 'null' if value.nil?

          if value.is_a?(Array)
            value.each { |name| expect_selected_option(name.to_s) }
          else
            element = page.find("input[name='custom_action[actions][#{name}]']", visible: :all)
            expect(element.value).to eq value.to_s
          end
        end

        def set_action(name, value)
          set_action_value(name, value)
        rescue Capybara::ElementNotFound
          add_action(name, value)
        end

        def set_condition(name, value)
          page.within('#custom-actions-form--conditions') do
            page.find_field(name)
          end

          Array(value).each do |val|
            within '#custom-actions-form--conditions' do
              fill_in name, with: val
            end

            find('.ng-option', wait: 5, text: val).click

            within '#custom-actions-form--conditions' do
              expect_selected_option val
            end

            sleep 1
          end
        end

        private

        def set_action_value(name, value)
          field = find('#custom-actions-form--active-actions .form--field', text: name, wait: 5)

          autocomplete = false

          Array(value).each do |val|
            within field do
              if has_selector?('.form--selected-value--container', wait: 1)
                find('.form--selected-value--container').click
                autocomplete = true
              elsif has_selector?('.autocomplete-select-decoration--wrapper', wait: 1)
                autocomplete = true
              end

              target = page.find_field(name)
              target.send_keys val
            end

            if autocomplete
              dropdown_el = find('.ng-option', text: val, wait: 5)
              scroll_to_and_click(dropdown_el)
            end
          end
        end
      end
    end
  end
end
