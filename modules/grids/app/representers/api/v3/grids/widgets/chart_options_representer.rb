

module API
  module V3
    module Grids
      module Widgets
        class ChartOptionsRepresenter < QueryOptionsRepresenter
          property :chartType,
                   getter: ->(represented:, **) {
                     represented['chartType']
                   }
        end
      end
    end
  end
end
