#-- encoding: UTF-8

module API
  module V3
    module Relations
      class RelationPayloadRepresenter < RelationRepresenter
        include ::API::Utilities::PayloadRepresenter
      end
    end
  end
end
