

module Components
  class CostReportsBaseTable
    include Capybara::DSL
    include RSpec::Matchers

    attr_reader :time_logging_modal

    def initialize
      @time_logging_modal = Components::TimeLoggingModal.new
    end

    def rows_count(count)
      expect(page).to have_selector('#result-table tbody tr', count: count)
    end

    def expect_action_icon(icon, row, present: true)
      if present
        expect(page).to have_selector("#{row_selector(row)} .icon-#{icon}")
      else
        expect(page).to have_no_selector("#{row_selector(row)} .icon-#{icon}")
      end
    end

    def expect_value(value, row)
      expect(page).to have_selector("#{row_selector(row)} .units", text: value)
    end

    def edit_time_entry(new_value, row)
      SeleniumHubWaiter.wait
      page.find("#{row_selector(row)} .icon-edit").click

      time_logging_modal.is_visible true
      time_logging_modal.update_field 'hours', new_value
      time_logging_modal.work_package_is_missing false

      time_logging_modal.perform_action 'Save'
      SeleniumHubWaiter.wait

      expect_action_icon 'edit', row
      expect_value new_value, row
    end

    def edit_cost_entry(new_value, row, cost_entry_id)
      SeleniumHubWaiter.wait
      page.find("#{row_selector(row)} .icon-edit").click

      expect(page).to have_current_path('/cost_entries/' + cost_entry_id + '/edit')

      SeleniumHubWaiter.wait
      fill_in('cost_entry_units', with: new_value)
      click_button 'Save'
      expect(page).to have_selector('.flash.notice')
    end

    def delete_entry(row)
      SeleniumHubWaiter.wait
      page.find("#{row_selector(row)} .icon-delete").click

      page.driver.browser.switch_to.alert.accept
    end

    private

    def row_selector(row)
      "#result-table tbody tr:nth-of-type(#{row})"
    end
  end
end
