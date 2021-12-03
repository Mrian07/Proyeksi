module API
  module V3
    module Utilities
      module Endpoints
        module V3Deductions
          private

          def deduce_parse_service
            API::V3::ParseResourceParamsService
          end

          def deduce_render_representer
            "::API::V3::#{deduce_api_namespace}::#{api_name}Representer".constantize
          end

          def deduce_parse_representer
            "::API::V3::#{deduce_api_namespace}::#{api_name}PayloadRepresenter".constantize
          end
        end
      end
    end
  end
end
