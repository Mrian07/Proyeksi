#-- encoding: UTF-8



module API
  module V3
    module Statuses
      class StatusRepresenter < ::API::Decorators::Single
        include API::Caching::CachedRepresenter

        self_link

        property :id, render_nil: true
        property :name
        property :is_closed, render_nil: true
        property :color,
                 getter: ->(*) { color.hexcode if color },
                 render_nil: true
        property :is_default, render_nil: true
        property :is_readonly, render_nil: true
        property :default_done_ratio, render_nil: true
        property :position, render_nil: true

        def _type
          'Status'
        end
      end
    end
  end
end
