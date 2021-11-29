#-- encoding: UTF-8



module API
  module V3
    module Users
      class UserPayloadRepresenter < UserRepresenter
        include ::API::Utilities::PayloadRepresenter

        cached_representer disabled: true
      end
    end
  end
end
