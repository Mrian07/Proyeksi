

module API
  module V3
    module Grids
      module Widgets
        class DefaultOptionsRepresenter < ::API::Decorators::Single
          property :name,
                   getter: ->(represented:, **) {
                     represented['name']
                   }
        end
      end
    end
  end
end
