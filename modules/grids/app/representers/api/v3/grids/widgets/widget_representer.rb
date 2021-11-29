

module API
  module V3
    module Grids
      module Widgets
        class WidgetRepresenter < ::API::Decorators::Single
          property :id
          property :identifier
          property :start_row
          property :end_row
          property :start_column
          property :end_column

          property :options,
                   getter: ->(represented:, decorator:, **) {
                     ::Grids::Configuration
                       .widget_strategy(represented.grid.class, represented.identifier)
                       .options_representer
                       .constantize
                       .new(represented.options.with_indifferent_access.merge(grid: represented.grid),
                            current_user: decorator.current_user)
                   }

          def _type
            'GridWidget'
          end
        end
      end
    end
  end
end
