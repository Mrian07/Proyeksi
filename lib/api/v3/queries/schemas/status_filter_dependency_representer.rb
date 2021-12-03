#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class StatusFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def href_callback
            api_v3_paths.statuses
          end

          def type
            "[]Status"
          end
        end
      end
    end
  end
end
