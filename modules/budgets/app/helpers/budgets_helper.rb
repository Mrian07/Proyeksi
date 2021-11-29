

require 'csv'

module BudgetsHelper
  include ActionView::Helpers::NumberHelper
  include Redmine::I18n

  # Check if the current user is allowed to manage the budget.  Based on Role
  # permissions.
  def allowed_management?
    User.current.allowed_to?(:edit_budgets, @project)
  end

  def budgets_to_csv(budgets)
    CSV.generate(col_sep: t(:general_csv_separator)) do |csv|
      # csv header fields
      headers = [
        '#',
        Project.model_name.human,
        Budget.human_attribute_name(:subject),
        Budget.human_attribute_name(:author),
        Budget.human_attribute_name(:fixed_date),
        Budget.human_attribute_name(:material_budget),
        Budget.human_attribute_name(:labor_budget),
        Budget.human_attribute_name(:spent),
        Budget.human_attribute_name(:created_at),
        Budget.human_attribute_name(:updated_at),
        Budget.human_attribute_name(:description)
      ]
      csv << headers.map { |c| begin; c.to_s.encode('UTF-8'); rescue StandardError; c.to_s; end }
      # csv lines
      budgets.each do |budget|
        fields = [
          budget.id,
          budget.project.name,
          budget.subject,
          budget.author.name,
          format_date(budget.fixed_date),
          number_to_currency(budget.material_budget),
          number_to_currency(budget.labor_budget),
          number_to_currency(budget.spent),
          format_time(budget.created_at),
          format_time(budget.updated_at),
          budget.description
        ]
        csv << fields.map { |c| begin; c.to_s.encode('UTF-8'); rescue StandardError; c.to_s; end }
      end
    end
  end

  def budget_attachment_representer(message)
    ::API::V3::Budgets::BudgetRepresenter.new(message,
                                              current_user: current_user,
                                              embed_links: true)
  end
end
