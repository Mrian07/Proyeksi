#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class DateTimeFilterDependencyRepresenter <
          IntegerFilterDependencyRepresenter
          def type
            if operator == ::Queries::Operators::OnDateTime
              '[1]DateTime'
            elsif operator == ::Queries::Operators::BetweenDateTime
              '[2]DateTime'
            else
              super
            end
          end
        end
      end
    end
  end
end
