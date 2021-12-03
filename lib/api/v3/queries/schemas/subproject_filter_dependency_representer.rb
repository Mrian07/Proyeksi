#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class SubprojectFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def json_cache_key
            if filter.project
              super + [filter.project.id]
            else
              super
            end
          end

          def href_callback
            params = [ancestor: { operator: '=', values: [filter.project.id.to_s] }]
            escaped = CGI.escape(::JSON.dump(params))

            "#{api_v3_paths.projects}?filters=#{escaped}"
          end

          def type
            "[]Project"
          end
        end
      end
    end
  end
end
