

module API
  module V3
    module Projects
      module Copy
        class ParseCopyParamsService < ::API::V3::ParseResourceParamsService
          private

          def parse_attributes(request_body)
            attributes = super
            meta = attributes.delete(:meta) || {}

            {
              target_project_params: attributes,
              attributes_only: true,
              only: meta[:only],
              send_notifications: meta[:send_notifications] != false
            }
          end
        end
      end
    end
  end
end
