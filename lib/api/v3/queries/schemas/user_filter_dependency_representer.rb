#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Schemas
        class UserFilterDependencyRepresenter <
          PrincipalFilterDependencyRepresenter
          def json_cache_key
            super + (filter.project.present? ? [filter.project.id] : [])
          end

          private

          def filter_query
            params = [{ type: { operator: '=',
                                values: %w[User Group PlaceholderUser] } },
                      { status: { operator: '!',
                                  values: [Principal.statuses[:locked].to_s] } }]

            if filter.project
              params << { member: { operator: '=', values: [filter.project.id.to_s] } }
            end

            params
          end
        end
      end
    end
  end
end
