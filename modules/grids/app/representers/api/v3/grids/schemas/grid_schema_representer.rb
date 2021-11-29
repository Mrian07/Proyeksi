#-- encoding: UTF-8



module API
  module V3
    module Grids
      module Schemas
        class GridSchemaRepresenter < ::API::Decorators::SchemaRepresenter
          def initialize(represented, self_link: nil, current_user: nil, form_embedded: false)
            super(represented,
                  self_link: self_link,
                  current_user: current_user,
                  form_embedded: form_embedded)
          end

          schema :id,
                 type: 'Integer'

          schema :created_at,
                 type: 'DateTime'

          schema :updated_at,
                 type: 'DateTime'

          schema :row_count,
                 type: 'Integer'

          schema :column_count,
                 type: 'Integer'

          schema :name,
                 type: 'String'

          schema :options,
                 type: 'JSON'

          schema_with_allowed_collection :scope,
                                         type: 'Href',
                                         required: true,
                                         has_default: false,
                                         value_representer: false,
                                         link_factory: ->(path) {
                                           {
                                             href: path
                                           }
                                         }

          schema_with_allowed_collection :widgets,
                                         type: '[]GridWidget',
                                         required: true,
                                         has_default: false,
                                         values_callback: -> do
                                           represented.assignable_widgets.map do |identifier|
                                             OpenStruct.new(identifier: identifier, grid: represented.model, options: {})
                                           end
                                         end,
                                         value_representer: ::API::V3::Grids::Widgets::WidgetRepresenter,
                                         link_factory: false

          def self.represented_class
            ::Grids::Grid
          end

          def _dependencies
            nil
          end
        end
      end
    end
  end
end
