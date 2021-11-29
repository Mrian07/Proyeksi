

require 'support/pages/page'
require_relative 'budget_form'

module Pages
  class NewBudget < Page
    include ::Pages::BudgetForm

    attr_reader :project_identifier

    def initialize(project_identifier)
      @project_identifier = project_identifier
    end

    def path
      "/projects/#{project_identifier}/budgets/new"
    end
  end
end
