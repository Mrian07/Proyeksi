#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Columns
        class QueryRelationToTypeColumnRepresenter < QueryColumnRepresenter
          link :type do
            {
              href: api_v3_paths.type(represented.type.id),
              title: represented.type.name
            }
          end

          def _type
            'QueryColumn::RelationToType'
          end

          def json_cache_key
            [represented.name, represented.type.cache_key]
          end
        end
      end
    end
  end
end
