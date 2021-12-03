#-- encoding: UTF-8

module API
  module V3
    module Projects
      module Schemas
        class ProjectSchemaRepresenter < ::API::Decorators::SchemaRepresenter
          extend ::API::V3::Utilities::CustomFieldInjector::RepresenterClass
          custom_field_injector type: :schema_representer

          schema :id,
                 type: 'Integer'

          schema :name,
                 type: 'String',
                 min_length: 1,
                 max_length: 255

          schema :identifier,
                 type: 'String',
                 required: true,
                 has_default: true,
                 min_length: 1,
                 max_length: 100

          schema :description,
                 type: 'Formattable',
                 required: false

          schema :public,
                 type: 'Boolean',
                 required: false

          schema :active,
                 type: 'Boolean',
                 required: false

          schema_with_allowed_collection :status,
                                         type: 'ProjectStatus',
                                         name_source: ->(*) { I18n.t('activerecord.attributes.projects/status.code') },
                                         required: false,
                                         writable: ->(*) { represented.writable?(:status) },
                                         values_callback: ->(*) {
                                           ::Projects::Status.codes.keys
                                         },
                                         value_representer: ::API::V3::Projects::Statuses::StatusRepresenter,
                                         link_factory: ->(value) {
                                           {
                                             href: api_v3_paths.project_status(value),
                                             title: I18n.t(:"activerecord.attributes.projects/status.codes.#{value}")
                                           }
                                         }

          schema :status_explanation,
                 type: 'Formattable',
                 name_source: ->(*) { I18n.t('activerecord.attributes.projects/status.explanation') },
                 required: false,
                 writable: ->(*) { represented.writable?(:status) }

          schema_with_allowed_link :parent,
                                   type: 'Project',
                                   required: ->(*) {
                                     # Users only having the add_subprojects permission need to provide
                                     # a parent when creating a new project.
                                     represented.model.new_record? &&
                                       !current_user.allowed_to_globally?(:add_project)
                                   },
                                   href_callback: ->(*) {
                                     query_props = if represented.model.new_record?
                                                     ''
                                                   else
                                                     "?of=#{represented.model.id}"
                                                   end

                                     api_v3_paths.projects_available_parents + query_props
                                   }

          schema :created_at,
                 type: 'DateTime'

          schema :updated_at,
                 type: 'DateTime'

          def self.represented_class
            ::Project
          end
        end
      end
    end
  end
end
