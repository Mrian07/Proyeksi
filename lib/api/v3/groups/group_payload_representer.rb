#-- encoding: UTF-8

module API
  module V3
    module Groups
      class GroupPayloadRepresenter < GroupRepresenter
        include ::API::Utilities::PayloadRepresenter
      end
    end
  end
end
