module API
  module V3
    module Relations
      module RelationsHelper
        def representer
          ::API::V3::Relations::RelationRepresenter
        end

        def parse_representer
          ::API::V3::Relations::RelationPayloadRepresenter
        end
      end
    end
  end
end
