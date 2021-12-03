#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class FilterDependencyDecorator
          include ::API::V3::Utilities::PathHelper

          def initialize(filter, operator)
            self.filter = filter
            self.operator = operator
          end

          def href_callback
            api_v3_paths.statuses
          end

          def type
            "[]Status"
          end

          attr_accessor :filter, :operator
        end
      end
    end
  end
end
