

module API
  module V3
    module Boards
      module Widgets
        class BoardOptionsRepresenter < ::API::V3::Grids::Widgets::DefaultOptionsRepresenter
          property :queryId,
                   getter: ->(represented:, **) {
                     represented['queryId'] || represented['query_id']
                   }

          property :filters,
                   getter: ->(represented:, **) {
                     represented['filters']
                   }
        end
      end
    end
  end
end
