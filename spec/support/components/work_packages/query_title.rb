

module Components
  module WorkPackages
    class QueryTitle
      include Capybara::DSL
      include RSpec::Matchers

      def expect_changed
        expect(page).to have_selector '.editable-toolbar-title--save'
        expect(page).to have_selector '.editable-toolbar-title--input.-changed'
      end

      def expect_not_changed
        expect(page).to have_no_selector '.editable-toolbar-title--save'
        expect(page).to have_no_selector '.editable-toolbar-title--input.-changed'
      end

      def input_field
        find('.editable-toolbar-title--input')
      end

      def expect_title(name)
        expect(page).to have_field('editable-toolbar-title', with: name)
      end

      def press_save_button
        find('.editable-toolbar-title--save').click
      end

      def rename(name, save: true)
        fill_in 'editable-toolbar-title', with: name

        if save
          input_field.send_keys :return
        end
      end
    end
  end
end
