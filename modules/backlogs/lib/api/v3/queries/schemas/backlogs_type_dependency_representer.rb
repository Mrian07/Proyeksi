

module API
  module V3
    module Queries
      module Schemas
        class BacklogsTypeDependencyRepresenter <
          FilterDependencyRepresenter
          schema_with_allowed_collection :values,
                                         type: ->(*) { type },
                                         writable: true,
                                         has_default: false,
                                         required: true,
                                         values_callback: ->(*) {
                                           represented.allowed_values
                                         },
                                         value_representer: BacklogsTypes::BacklogsTypeRepresenter,
                                         link_factory: ->(value) {
                                           {
                                             href: api_v3_paths.backlogs_type(value.last),
                                             title: value.first
                                           }
                                         },
                                         show_if: ->(*) {
                                           value_required?
                                         }

          def href_callback; end

          private

          def type
            '[1]BacklogsType'
          end
        end
      end
    end
  end
end
