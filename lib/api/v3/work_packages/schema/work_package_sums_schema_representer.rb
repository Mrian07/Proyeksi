#-- encoding: UTF-8



require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module WorkPackages
      module Schema
        class WorkPackageSumsSchemaRepresenter < ::API::Decorators::SchemaRepresenter
          extend ::API::V3::Utilities::CustomFieldInjector::RepresenterClass

          custom_field_injector(type: :schema_representer,
                                injector_class: ::API::V3::Utilities::CustomFieldSumInjector)

          class << self
            def represented_class
              WorkPackage
            end
          end

          link :self do
            { href: api_v3_paths.work_package_sums_schema }
          end

          schema :estimated_time,
                 type: 'Duration',
                 required: false,
                 writable: false

          schema :story_points,
                 type: 'Integer',
                 required: false

          schema :remaining_time,
                 type: 'Duration',
                 name_source: :remaining_hours,
                 required: false,
                 writable: false

          schema :overall_costs,
                 type: 'String',
                 required: false,
                 writable: false

          schema :labor_costs,
                 type: 'String',
                 required: false,
                 writable: false

          schema :material_costs,
                 type: 'String',
                 required: false,
                 writable: false
        end
      end
    end
  end
end
