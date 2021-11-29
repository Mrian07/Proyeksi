#-- encoding: UTF-8



module API
  module V3
    module Memberships
      class MembershipPayloadRepresenter < MembershipRepresenter
        include ::API::Utilities::PayloadRepresenter
        include ::API::Utilities::MetaProperty

        def meta_representer_class
          MembershipMetaRepresenter
        end
      end
    end
  end
end
