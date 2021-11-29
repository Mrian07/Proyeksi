

module API
  module V3
    module Grids
      module Widgets
        class QueryOptionsRepresenter < DefaultOptionsRepresenter
          property :queryId,
                   getter: ->(represented:, **) {
                     represented['queryId']
                   }

          # This is required for initialization where the values
          # are stored like this so the front end can then initialize it.
          property :queryProps,
                   getter: ->(represented:, **) {
                     represented['queryProps']
                   }
        end
      end
    end
  end
end
