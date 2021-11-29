

module Components
  module WorkPackages
    class TableConfigurationModal
      include Capybara::DSL
      include RSpec::Matchers

      attr_accessor :trigger_parent

      def initialize(trigger_parent = nil)
        self.trigger_parent = trigger_parent
      end

      def self.do_and_save
        new.tap do |modal|
          yield modal
          modal.save
        end
      end

      def open_and_switch_to(name)
        open!
        switch_to(name)
      end

      def open_and_set_display_mode(mode)
        open_and_switch_to 'Display settings'
        choose("display_mode_switch", option: mode)
      end

      def open!
        SeleniumHubWaiter.wait
        scroll_to_and_click trigger
        expect_open
      end

      def set_display_sums(enable: true)
        open_and_switch_to 'Display settings'

        if enable
          check 'display_sums_switch'
        else
          uncheck 'display_sums_switch'
        end
        save
      end

      def save
        find("#{selector} .button.-highlight").click
      end

      def cancel
        find("#{selector} .button", text: 'Cancel').click
      end

      def expect_open
        expect(page).to have_selector(selector, wait: 40)
      end

      def expect_closed
        expect(page).to have_no_selector(selector)
      end

      def expect_disabled_tab(name)
        expect(page).to have_selector("#{selector} [data-qa-tab-disabled]", text: name.upcase)
      end

      def selected_tab(name)
        page.find("#{selector} .op-tab-row--link_selected", text: name.upcase)
        page.find("#{selector} .tab-content[data-tab-name='#{name}']")
      end

      def switch_to(target)
        # Switching too fast may result in the click handler not yet firing
        # so wait a bit initially
        SeleniumHubWaiter.wait

        retry_block do
          find("#{selector} .op-tab-row--link", text: target.upcase, wait: 2).click
          selected_tab(target)
        end
      end

      def selector
        '.op-modal'
      end

      private

      def trigger
        if trigger_parent
          within trigger_parent do
            find('.wp-table--configuration-modal--trigger')
          end
        else
          find('.wp-table--configuration-modal--trigger')
        end
      end
    end
  end
end
