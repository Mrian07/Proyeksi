

module Queries::WorkPackages::Filter
  class BudgetFilter < ::Queries::WorkPackages::Filter::WorkPackageFilter
    def allowed_values
      budgets
        .pluck(:subject, :id)
    end

    def available?
      project&.module_enabled?(:budgets)
    end

    def self.key
      :budget_id
    end

    def type
      :list_optional
    end

    def dependency_class
      '::API::V3::Queries::Schemas::BudgetFilterDependencyRepresenter'
    end

    def ar_object_filter?
      true
    end

    def value_objects
      available_budgets = budgets.index_by(&:id)

      values
        .map { |budget_id| available_budgets[budget_id.to_i] }
        .compact
    end

    def human_name
      WorkPackage.human_attribute_name(:budget)
    end

    private

    def budgets
      Budget
        .where(project_id: project)
        .order(Arel.sql('subject ASC'))
    end
  end
end
