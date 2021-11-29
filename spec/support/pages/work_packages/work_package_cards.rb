
require 'support/pages/page'

module Pages
  class WorkPackageCards < Page
    include Capybara::DSL
    include RSpec::Matchers
    attr_reader :project

    def initialize(project = nil)
      @project = project
    end

    def expect_work_package_listed(*work_packages)
      work_packages.each do |wp|
        expect(page).to have_selector("wp-single-card[data-work-package-id='#{wp.id}']", wait: 10)
      end
    end

    def expect_work_package_not_listed(*work_packages)
      work_packages.each do |wp|
        expect(page).not_to have_selector("wp-single-card[data-work-package-id='#{wp.id}']")
      end
    end

    def expect_work_package_order(*ids)
      retry_block do
        rows = page.all 'wp-single-card'
        expected = ids.map { |el| el.is_a?(WorkPackage) ? el.id.to_s : el.to_s }
        found = rows.map { |el| el['data-work-package-id'] }

        raise "Order is incorrect: #{found.inspect} != #{expected.inspect}" unless found == expected
      end
    end

    def open_full_screen_by_doubleclick(work_package)
      retry_block do
        loading_indicator_saveguard
        page.driver.browser.action.double_click(card(work_package).native).perform

        # Ensure we show the subject field
        page.find('.work-packages--subject-type-row')
      end

      Pages::FullWorkPackage.new(work_package, project)
    end

    def open_full_screen_by_details(work_package)
      element = card(work_package)
      scroll_to_element(element)
      element.hover
      element.find('[data-qa-selector="op-wp-single-card--details-button"]').click

      ::Pages::SplitWorkPackage.new(work_package, project)
    end

    def select_work_package(work_package)
      card(work_package).click
    end

    def click_info_icon(work_package)
      card_element = card(work_package)
      card_element.hover
      card_element.find('[data-qa-selector="op-wp-single-card--details-button"]').click
    end

    def deselect_work_package(work_package)
      element = find("wp-single-card[data-work-package-id='#{work_package.id}']")

      page.driver.browser.action.key_down(:command)
        .click(element.native)
        .key_up(:command)
        .perform
    end

    def select_work_package_with_shift(work_package)
      element = find("wp-single-card[data-work-package-id='#{work_package.id}']")

      page.driver.browser.action.key_down(:shift)
        .click(element.native)
        .key_up(:shift)
        .perform
    end

    def select_all_work_packages
      find('body').send_keys [:control, 'a']
      expect(page).to have_no_selector '#work-package-context-menu'
    end

    def deselect_all_work_packages
      find('body').send_keys [:control, 'd']
      expect(page).to have_no_selector '#work-package-context-menu'
    end

    def card(work_package)
      page.find(".op-wp-single-card-#{work_package.id}")
    end

    def status_button(work_package)
      WorkPackageStatusField.new card(work_package)
    end

    def expect_work_package_selected(work_package, selected)
      selector = "wp-single-card[data-work-package-id='#{work_package.id}']"
      checked_selector = "wp-single-card[data-work-package-id='#{work_package.id}'] [data-qa-checked='true']"

      expect(page).to have_selector(selector)
      expect(page).to (selected ? have_selector(checked_selector) : have_no_selector(checked_selector))
    end
  end
end
