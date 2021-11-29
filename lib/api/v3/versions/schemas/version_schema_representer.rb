#-- encoding: UTF-8



module API
  module V3
    module Versions
      module Schemas
        class VersionSchemaRepresenter < ::API::Decorators::SchemaRepresenter
          extend ::API::V3::Utilities::CustomFieldInjector::RepresenterClass

          custom_field_injector type: :schema_representer

          def initialize(represented, self_link: nil, current_user: nil, form_embedded: false)
            super(represented,
                  self_link: self_link,
                  current_user: current_user,
                  form_embedded: form_embedded)
          end

          schema :id,
                 type: 'Integer'

          schema :name,
                 type: 'String',
                 min_length: 1,
                 max_length: 60

          schema :description,
                 type: 'Formattable',
                 required: false

          schema :start_date,
                 type: 'Date',
                 required: false

          schema :due_date,
                 as: 'endDate',
                 type: 'Date',
                 required: false

          schema_with_allowed_string_collection :status,
                                                type: 'String'

          schema_with_allowed_string_collection :sharing,
                                                type: 'String'

          schema_with_allowed_link :project,
                                   as: :definingProject,
                                   has_default: false,
                                   required: true,
                                   href_callback: ->(*) {
                                     next unless represented.new_record?

                                     api_v3_paths.versions_available_projects
                                   }

          schema :created_at,
                 type: 'DateTime'

          schema :updated_at,
                 type: 'DateTime'

          def self.represented_class
            Version
          end
        end
      end
    end
  end
end
