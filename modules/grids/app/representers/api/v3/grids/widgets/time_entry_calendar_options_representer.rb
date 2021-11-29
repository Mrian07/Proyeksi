

module API
  module V3
    module Grids
      module Widgets
        class TimeEntryCalendarOptionsRepresenter < DefaultOptionsRepresenter
          property :days,
                   getter: ->(represented:, **) {
                     represented['days'] || {}
                   }
        end
      end
    end
  end
end
