

module Components
  class AttributeHelpTextModal
    include Capybara::DSL
    include RSpec::Matchers

    attr_reader :help_text, :context

    def initialize(help_text, context: nil)
      @context = context
      @help_text = help_text
    end

    def container
      if context
        page.find(context)
      else
        page
      end
    end

    def modal_container
      container.find('.attribute-help-text--modal')
    end

    def open!
      SeleniumHubWaiter.wait
      container.find("[data-qa-help-text-for='#{help_text.attribute_name}']").click
      expect(page).to have_selector('.attribute-help-text--modal h1', text: help_text.attribute_caption)
    end

    def close!
      within modal_container do
        page.find('.icon-close').click
      end
      expect(page).to have_no_selector('.attribute-help-text--modal h1', text: help_text.attribute_caption)
    end

    def expect_edit(admin:)
      if admin
        expect(page).to have_selector('.help-text--edit-button')
      else
        expect(page).to have_no_selector('.help-text--edit-button')
      end
    end

    def edit_button
      page.find('.help-text--edit-button')
    end
  end
end
