

module API
  module V3
    module CostTypes
      class CostTypeRepresenter < ::API::Decorators::Single
        self_link
        property :id, render_nil: true
        property :name, render_nil: true
        property :unit,
                 render_nil: true
        property :unit_plural,
                 render_nil: true
        property :is_default,
                 getter: ->(*) { default }

        def _type
          'CostType'
        end
      end
    end
  end
end
