#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class VersionFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def json_cache_key
            super + (filter.project.present? ? [filter.project.id] : [])
          end

          def href_callback
            order = "sortBy=#{to_query [%i(semver_name asc)]}"

            if filter.project.nil?
              filter_params = [{ sharing: { operator: '=', values: ['system'] } }]

              "#{api_v3_paths.versions}?filters=#{to_query filter_params}&#{order}"
            else
              "#{api_v3_paths.versions_by_project(filter.project.id)}?#{order}"
            end
          end

          def type
            "[]Version"
          end

          private

          def to_query(param)
            CGI.escape(::JSON.dump(param))
          end
        end
      end
    end
  end
end
