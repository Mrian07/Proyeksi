#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Schemas
        class IntegerFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def href_callback; end

          private

          def type
            '[1]Integer'
          end
        end
      end
    end
  end
end
