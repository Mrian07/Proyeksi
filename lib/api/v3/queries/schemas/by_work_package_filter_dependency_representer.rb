#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class ByWorkPackageFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def json_cache_key
            super + (filter.project.present? ? [filter.project.id] : [])
          end

          def href_callback
            if filter.project
              api_v3_paths.work_packages_by_project(filter.project.id)
            else
              api_v3_paths.work_packages
            end
          end

          private

          def type
            '[]WorkPackage'
          end
        end
      end
    end
  end
end
