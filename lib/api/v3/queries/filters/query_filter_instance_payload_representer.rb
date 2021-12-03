#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Filters
        class QueryFilterInstancePayloadRepresenter < QueryFilterInstanceRepresenter
          include ::API::Utilities::PayloadRepresenter

          def initialize(model)
            super(model)
          end
        end
      end
    end
  end
end
