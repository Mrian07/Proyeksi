

require 'support/pages/page'

module Pages
  class WorkPackageCard < Page
    attr_reader :project, :work_package

    def initialize(work_package, project = nil)
      @work_package = work_package
      @project = project || work_package.project
    end

    def card_element
      page.find(card_selector)
    end

    def card_selector
      ".op-wp-single-card-#{work_package.id}"
    end

    def expect_selected
      expect(page).to have_selector("#{card_selector}[data-qa-checked='true']")
    end

    def expect_type(name)
      page.within(card_element) do
        expect(page).to have_selector('[data-qa-selector="op-wp-single-card--content-type"]', text: name.upcase)
      end
    end

    def expect_subject(subject)
      page.within(card_element) do
        expect(page).to have_selector('[data-qa-selector="op-wp-single-card--content-subject"]', text: subject)
      end
    end

    def open_details_view
      card_element.hover
      card_element.find('[data-qa-selector="op-wp-single-card--details-button"]').click

      ::Pages::SplitWorkPackage.new work_package
    end
  end
end
