#-- encoding: UTF-8



module API
  module V3
    module Memberships
      class MembershipMetaRepresenter < ::API::Decorators::Single
        include API::Decorators::FormattableProperty

        formattable_property :notification_message

        def model_required?
          false
        end
      end
    end
  end
end
