#-- encoding: UTF-8

module API
  module V3
    module WorkPackages
      class WorkPackagePayloadRepresenter < WorkPackageRepresenter
        include ::API::Utilities::PayloadRepresenter
        include ::API::V3::Attachments::AttachablePayloadRepresenterMixin

        cached_representer disabled: true

        def writeable_attributes
          super + %w[date]
        end

        def load_complete_model(model)
          model
        end
      end
    end
  end
end
