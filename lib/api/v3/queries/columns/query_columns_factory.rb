

module API
  module V3
    module Queries
      module Columns
        module QueryColumnsFactory
          def self.representer(column)
            case column
            when ::Queries::WorkPackages::Columns::RelationToTypeColumn
              ::API::V3::Queries::Columns::QueryRelationToTypeColumnRepresenter
            when ::Queries::WorkPackages::Columns::RelationOfTypeColumn
              ::API::V3::Queries::Columns::QueryRelationOfTypeColumnRepresenter
            else
              ::API::V3::Queries::Columns::QueryPropertyColumnRepresenter
            end
          end

          def self.create(column)
            representer(column).new(column)
          end
        end
      end
    end
  end
end
