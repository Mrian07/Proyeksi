#-- encoding: UTF-8



module API
  module V3
    module Queries
      class QueryPayloadRepresenter < QueryRepresenter
        include ::API::Utilities::PayloadRepresenter

        def filters
          represented.filters.map do |filter|
            ::API::V3::Queries::Filters::QueryFilterInstancePayloadRepresenter
              .new(filter)
          end
        end
      end
    end
  end
end
