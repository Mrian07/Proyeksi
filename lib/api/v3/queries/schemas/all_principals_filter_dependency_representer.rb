#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Schemas
        class AllPrincipalsFilterDependencyRepresenter <
          PrincipalFilterDependencyRepresenter
          def json_cache_key
            if filter.project
              super + [filter.project.id]
            else
              super
            end
          end

          private

          def filter_query
            params = [{ status: { operator: '!',
                                  values: [Principal.statuses[:locked].to_s] } }]

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
