#-- encoding: UTF-8

require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module Priorities
      class PriorityRepresenter < ::API::Decorators::Single
        include API::Caching::CachedRepresenter

        self_link

        property :id, render_nil: true
        property :name
        property :position
        property :color,
                 getter: ->(*) { color.hexcode if color },
                 render_nil: true
        property :is_default
        property :active, as: :isActive

        def _type
          'Priority'
        end
      end
    end
  end
end
