

module Components
  class ConfirmationDialog
    include Capybara::DSL
    include RSpec::Matchers

    def initialize; end

    def container
      '.op-modal'
    end

    def expect_open
      expect(page).to have_selector(container)
    end

    def confirm
      page.within(container) do
        page.find('.confirm-form-submit--continue').click
      end
    end

    def cancel
      page.within(container) do
        page.find('.confirm-form-submit--cancel').click
      end
    end
  end
end
