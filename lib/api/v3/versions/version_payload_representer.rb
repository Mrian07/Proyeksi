#-- encoding: UTF-8



module API
  module V3
    module Versions
      class VersionPayloadRepresenter < VersionRepresenter
        include ::API::Utilities::PayloadRepresenter

        cached_representer disabled: true

        def writeable_attributes
          @writeable_attributes ||= begin
            static = if represented.new_record?
                       %w[endDate definingProject]
                     else
                       %w[endDate]
                     end
            super +
              static +
              represented.custom_field_values.map { |cv| "customField#{cv.custom_field_id}" }
          end
        end
      end
    end
  end
end
