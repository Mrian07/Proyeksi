#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class CustomOptionFilterDependencyRepresenter <
          FilterDependencyRepresenter
          schema_with_allowed_collection :values,
                                         type: ->(*) { type },
                                         writable: true,
                                         has_default: false,
                                         required: true,
                                         values_callback: ->(*) {
                                           represented.custom_field.custom_options
                                         },
                                         value_representer: CustomOptions::CustomOptionRepresenter,
                                         link_factory: ->(value) {
                                           {
                                             href: api_v3_paths.custom_option(value.id),
                                             title: value.to_s
                                           }
                                         },
                                         show_if: ->(*) {
                                           value_required?
                                         }

          private

          def type
            '[]CustomOption'
          end
        end
      end
    end
  end
end
