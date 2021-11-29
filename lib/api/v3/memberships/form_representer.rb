#-- encoding: UTF-8



module API
  module V3
    module Memberships
      class FormRepresenter < ::API::Decorators::SimpleForm
        include ::API::Decorators::MetaForm

        def model
          Member
        end

        private

        def payload_representer_class
          API::V3::Memberships::MembershipPayloadRepresenter
        end

        def schema_representer_class
          API::V3::Memberships::Schemas::MembershipSchemaRepresenter
        end
      end
    end
  end
end
