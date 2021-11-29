

require 'support/pages/page'

module Pages
  class IndexBudget < Page
    attr_accessor :project

    def initialize(project)
      self.project = project
    end

    def expect_budget_not_listed(budget_name)
      expect(page)
        .not_to have_content(budget_name)
    end

    def path
      budgets_path(project)
    end
  end
end
