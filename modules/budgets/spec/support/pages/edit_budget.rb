

require 'support/pages/page'
require_relative 'budget_form'

module Pages
  class EditBudget < Page
    include ::Pages::BudgetForm

    attr_reader :budget_id # budget == budget

    def initialize(budget_id)
      @budget_id = budget_id
    end

    def click_copy
      within '.toolbar-items' do
        click_link 'Copy'
      end
    end

    def click_delete
      within '.toolbar-items' do
        click_link 'Delete'
      end
    end

    def path
      "/budgets/#{budget_id}"
    end
  end
end
