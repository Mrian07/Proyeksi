#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Columns
        class QueryRelationOfTypeColumnRepresenter < QueryColumnRepresenter
          def _type
            'QueryColumn::RelationOfType'
          end

          property :relation_type
        end

        def json_cache_key
          [represented.name]
        end
      end
    end
  end
end
