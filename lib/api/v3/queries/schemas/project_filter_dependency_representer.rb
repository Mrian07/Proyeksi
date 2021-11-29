#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Schemas
        class ProjectFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def href_callback
            params = [active: { operator: '=', values: ['t'] }]
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
