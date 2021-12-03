#-- encoding: UTF-8

module API
  module V3
    module Types
      class TypeRepresenter < ::API::Decorators::Single
        include API::Decorators::DateProperty
        include ::API::Caching::CachedRepresenter

        self_link

        property :id
        property :name
        property :color,
                 getter: ->(*) { color.hexcode if color },
                 render_nil: true
        property :position
        property :is_default
        property :is_milestone

        date_time_property :created_at
        date_time_property :updated_at

        def _type
          'Type'
        end
      end
    end
  end
end
