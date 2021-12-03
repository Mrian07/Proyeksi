#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class TextFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def href_callback; end

          private

          def type
            '[1]String'
          end
        end
      end
    end
  end
end
