#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Schemas
        class CategoryFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def json_cache_key
            super + [filter.project.id]
          end

          def href_callback
            # This filter is only available inside projects
            api_v3_paths.categories_by_project(filter.project.identifier)
          end

          def type
            "[]Category"
          end
        end
      end
    end
  end
end
