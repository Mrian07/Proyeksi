

module API
  module V3
    module Queries
      module Schemas
        class BudgetFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def href_callback
            api_v3_paths.budgets_by_project filter.project.id
          end

          def json_cache_key
            super + [filter.project.id]
          end

          def type
            "[]Budget"
          end
        end
      end
    end
  end
end
