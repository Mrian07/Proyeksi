

module API
  module V3
    module Grids
      module Widgets
        class CustomTextOptionsRepresenter < DefaultOptionsRepresenter
          include API::Decorators::FormattableProperty

          formattable_property :text,
                               getter: ->(*) do
                                 ::API::Decorators::Formattable.new(represented[:text],
                                                                    object: represented[:grid],
                                                                    plain: false)
                               end
        end
      end
    end
  end
end
