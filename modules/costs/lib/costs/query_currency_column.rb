

module Costs
  class QueryCurrencyColumn < Queries::WorkPackages::Columns::WorkPackageColumn
    include ActionView::Helpers::NumberHelper
    alias :super_value :value

    def initialize(name, options = {})
      super
    end

    def value(work_package)
      number_to_currency(work_package.send(name))
    end

    def real_value(work_package)
      super_value work_package
    end

    class_attribute :currency_columns

    self.currency_columns = {
      budget: {},
      material_costs: {
        summable: ->(query, grouped) {
          scope = WorkPackage::MaterialCosts
                  .new(user: User.current)
                  .add_to_work_package_collection(WorkPackage.where(id: query.results.work_packages))
                  .except(:order, :select)

          Queries::WorkPackages::Columns::WorkPackageColumn
            .scoped_column_sum(scope,
                               "COALESCE(ROUND(SUM(cost_entries_sum), 2)::FLOAT, 0.0) material_costs",
                               grouped && query.group_by_statement)
        }
      },
      labor_costs: {
        summable: ->(query, grouped) {
          scope = WorkPackage::LaborCosts
                  .new(user: User.current)
                  .add_to_work_package_collection(WorkPackage.where(id: query.results.work_packages))
                  .except(:order, :select)

          Queries::WorkPackages::Columns::WorkPackageColumn
            .scoped_column_sum(scope,
                               "COALESCE(ROUND(SUM(time_entries_sum), 2)::FLOAT, 0.0) labor_costs",
                               grouped && query.group_by_statement)
        }
      },
      overall_costs: {
        summable: true,
        summable_select: "labor_costs + material_costs AS overall_costs",
        summable_work_packages_select: false
      }
    }

    def self.instances(context = nil)
      return [] if context && !context.costs_enabled?

      currency_columns.map do |name, options|
        new(name, options)
      end
    end
  end
end
