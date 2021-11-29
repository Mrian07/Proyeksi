#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Filters
        class QueryFilterDecorator
          def initialize(filter)
            self.filter = filter
          end

          private

          attr_accessor :filter
        end
      end
    end
  end
end
