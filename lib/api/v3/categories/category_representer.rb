#-- encoding: UTF-8

require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module Categories
      class CategoryRepresenter < ::API::Decorators::Single
        include ::API::Caching::CachedRepresenter

        cached_representer key_parts: %i(assigned_to project)

        link :self do
          {
            href: api_v3_paths.category(represented.id),
            title: represented.name
          }
        end

        link :project do
          {
            href: api_v3_paths.project(represented.project.id),
            title: represented.project.name
          }
        end

        link :defaultAssignee do
          next unless represented.assigned_to

          {
            href: api_v3_paths.user(represented.assigned_to.id),
            title: represented.assigned_to.name
          }
        end

        property :id, render_nil: true
        property :name, render_nil: true

        def _type
          'Category'
        end
      end
    end
  end
end
