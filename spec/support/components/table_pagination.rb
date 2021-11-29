

module Components
  class TablePagination
    include Capybara::DSL
    include RSpec::Matchers

    def expect_range(from, to, total)
      within_pagination do
        expect(page)
          .to have_selector('.op-pagination--range', text: "(#{from} - #{to}/#{total})")
      end
    end

    def expect_no_per_page_options
      within_pagination do
        expect(page)
          .to have_no_selector('.op-pagination--options')
      end
    end

    protected

    def within_pagination(&block)
      within('.op-pagination', &block)
    end
  end
end
