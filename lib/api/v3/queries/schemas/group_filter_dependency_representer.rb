#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class GroupFilterDependencyRepresenter <
          PrincipalFilterDependencyRepresenter
          def json_cache_key
            super + (filter.project.present? ? [filter.project.id] : [])
          end

          private

          def filter_query
            params = [{ type: { operator: '=', values: ['Group'] } }]

            params << if filter.project
                        { member: { operator: '=', values: [filter.project.id.to_s] } }
                      else
                        { member: { operator: '*', values: [] } }
                      end
            params
          end
        end
      end
    end
  end
end
