#-- encoding: UTF-8



module API
  module V3
    module PlaceholderUsers
      class PlaceholderUserPayloadRepresenter < PlaceholderUserRepresenter
        include ::API::Utilities::PayloadRepresenter
      end
    end
  end
end
