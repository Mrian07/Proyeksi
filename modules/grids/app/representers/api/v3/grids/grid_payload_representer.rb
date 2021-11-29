#-- encoding: UTF-8



module API
  module V3
    module Grids
      class GridPayloadRepresenter < GridRepresenter
        include ::API::Utilities::PayloadRepresenter
        include ::API::V3::Attachments::AttachablePayloadRepresenterMixin

        cached_representer disabled: true

        def widget_representer_class
          Widgets::WidgetPayloadRepresenter
        end
      end
    end
  end
end
