#-- encoding: UTF-8

module API
  module V3
    module Users
      module Schemas
        class UserSchemaRepresenter < ::API::Decorators::SchemaRepresenter
          extend ::API::V3::Utilities::CustomFieldInjector::RepresenterClass
          custom_field_injector type: :schema_representer

          schema :id,
                 type: 'Integer'

          schema :login,
                 type: 'String',
                 min_length: 1,
                 max_length: 255

          schema :admin,
                 type: 'Boolean',
                 required: false

          schema :email,
                 type: 'String',
                 min_length: 1,
                 max_length: 255

          schema :name,
                 type: 'String',
                 required: false,
                 writable: false

          schema :firstname,
                 as: :firstName,
                 type: 'String',
                 min_length: 1,
                 max_length: 255

          schema :lastname,
                 as: :lastName,
                 type: 'String',
                 min_length: 1,
                 max_length: 255

          schema :avatar,
                 type: 'String',
                 writable: false,
                 required: false

          schema :status,
                 type: 'String',
                 required: false

          schema :identity_url,
                 type: 'String',
                 required: false

          schema :language,
                 type: 'String',
                 required: false

          schema :password,
                 type: 'Password',
                 required: false

          schema :created_at,
                 type: 'DateTime'

          schema :updated_at,
                 type: 'DateTime'

          def self.represented_class
            ::User
          end
        end
      end
    end
  end
end
