#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class PriorityFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def href_callback
            api_v3_paths.priorities
          end

          def type
            "[]Priority"
          end
        end
      end
    end
  end
end
