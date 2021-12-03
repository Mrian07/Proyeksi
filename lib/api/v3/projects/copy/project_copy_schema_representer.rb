#-- encoding: UTF-8

module API
  module V3
    module Projects
      module Copy
        class ProjectCopySchemaRepresenter < ::API::V3::Projects::Schemas::ProjectSchemaRepresenter
          extend ::API::V3::Utilities::CustomFieldInjector::RepresenterClass
          custom_field_injector type: :schema_representer

          ::Projects::CopyService.copyable_dependencies.each do |dep|
            identifier = dep[:identifier]
            name_source = dep[:name_source]

            schema :"copy_#{identifier}",
                   type: 'Boolean',
                   name_source: name_source,
                   has_default: true,
                   writable: true,
                   required: false,
                   description: -> do
                     count = dep[:count_source].call(represented.model, current_user)

                     I18n.t('copy_project.x_objects_of_this_type', count: count.to_i)
                   end,
                   location: :meta
          end

          schema :send_notifications,
                 type: 'Boolean',
                 name_source: ->(*) { I18n.t(:label_project_copy_notifications) },
                 has_default: true,
                 writable: true,
                 required: false,
                 location: :meta
        end
      end
    end
  end
end
