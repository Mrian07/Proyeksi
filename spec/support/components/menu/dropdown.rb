

module Components
  class Dropdown
    include Capybara::DSL
    include RSpec::Matchers

    def initialize; end

    def toggle
      trigger_element.click
    end

    def expect_closed
      expect(page).to have_no_selector('.op-app-menu--dropdown')
    end

    def expect_open
      expect(page).to have_selector('.op-app-menu--dropdown')
    end

    def within_dropdown(&block)
      page.within('.op-app-menu--dropdown', &block)
    end

    def trigger_element
      raise NotImplementedError
    end
  end
end
