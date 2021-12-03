#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class RoleFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def href_callback
            api_v3_paths.roles
          end

          def type
            "[]Role"
          end
        end
      end
    end
  end
end
