

module API
  module V3
    module TimeEntries
      class TimeEntryPayloadRepresenter < TimeEntryRepresenter
        include ::API::Utilities::PayloadRepresenter
      end
    end
  end
end
