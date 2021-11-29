#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Schemas
        class DateFilterDependencyRepresenter <
          IntegerFilterDependencyRepresenter
          private

          def type
            if operator == ::Queries::Operators::OnDate
              '[1]Date'
            elsif operator == ::Queries::Operators::BetweenDate
              '[2]Date'
            else
              super
            end
          end
        end
      end
    end
  end
end
