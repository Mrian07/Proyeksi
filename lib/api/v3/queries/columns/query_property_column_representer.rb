#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Columns
        class QueryPropertyColumnRepresenter < QueryColumnRepresenter
          def _type
            'QueryColumn::Property'
          end
        end
      end
    end
  end
end
