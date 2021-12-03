#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class TypeFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def json_cache_key
            super + (filter.project.present? ? [filter.project.id] : [])
          end

          def href_callback
            if filter.project.nil?
              api_v3_paths.types
            else
              api_v3_paths.types_by_project(filter.project.id)
            end
          end

          def type
            "[]Type"
          end
        end
      end
    end
  end
end
